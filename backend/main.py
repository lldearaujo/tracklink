"""
Main application entry point for the Link Tracking System
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from sqlalchemy.exc import OperationalError
import logging
import os

logger = logging.getLogger(__name__)

# Import database components
from app.core.database import engine, Base
from app.core.config import settings
from app.api import links, analytics, tracking

# Try to create database tables (only if connection is available)
try:
    Base.metadata.create_all(bind=engine)
    logger.info("Database tables created/verified successfully")
except OperationalError as e:
    logger.warning(f"Could not connect to database during startup: {e}")
    logger.warning("Application will start, but database operations may fail")
    logger.warning("Please check your database credentials in backend/.env")
except Exception as e:
    logger.error(f"Error creating database tables: {e}")

app = FastAPI(
    title="Link Tracking System - DOOH Analytics",
    description="Sistema de rastreamento de links com dashboard de métricas",
    version="1.0.0"
)

# CORS middleware - usar o método que converte para lista
cors_origins = settings.cors_origins_list

# Log para debug
logger.info(f"CORS origins configurados: {cors_origins}")

app.add_middleware(
    CORSMiddleware,
    allow_origins=cors_origins,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"],
    allow_headers=["*"],
    expose_headers=["*"],
    max_age=3600,
)

# Include routers (devem vir antes das rotas estáticas)
app.include_router(links.router, prefix="/api/links", tags=["links"])
app.include_router(analytics.router, prefix="/api/analytics", tags=["analytics"])
app.include_router(tracking.router, prefix="/r", tags=["tracking"])

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

# Servir arquivos estáticos do frontend (se existirem)
# O build do React fica em /app/static (copiado do Dockerfile)
static_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), "static")
if os.path.exists(static_dir):
    # Servir arquivos estáticos (JS, CSS, imagens, etc.) da subpasta static/
    static_assets_dir = os.path.join(static_dir, "static")
    if os.path.exists(static_assets_dir):
        app.mount("/static", StaticFiles(directory=static_assets_dir), name="static")
    
    # Servir index.html na raiz
    @app.get("/")
    async def root():
        index_path = os.path.join(static_dir, "index.html")
        if os.path.exists(index_path):
            return FileResponse(index_path)
        return {
            "message": "Link Tracking System API",
            "version": "1.0.0",
            "docs": "/docs"
        }
    
    # Catch-all: servir index.html para todas as rotas que não são da API
    # Isso permite que o React Router funcione corretamente
    @app.get("/{full_path:path}")
    async def serve_frontend(full_path: str):
        """
        Serve o frontend React para todas as rotas que não são da API.
        As rotas da API já foram registradas acima e têm prioridade.
        """
        # Verificar se é um arquivo estático (tem extensão)
        if "." in full_path.split("/")[-1] and not full_path.endswith(".html"):
            # Tentar servir o arquivo estático
            file_path = os.path.join(static_dir, full_path)
            if os.path.exists(file_path) and os.path.isfile(file_path):
                return FileResponse(file_path)
        
        # Para qualquer outra rota, servir index.html (React Router vai lidar)
        index_path = os.path.join(static_dir, "index.html")
        if os.path.exists(index_path):
            return FileResponse(index_path)
        return {"error": "Frontend not found"}
else:
    # Se não tiver frontend, retornar JSON da API
    @app.get("/")
    async def root():
        return {
            "message": "Link Tracking System API",
            "version": "1.0.0",
            "docs": "/docs"
        }
