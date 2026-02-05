"""
Main application entry point for the Link Tracking System
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.exc import OperationalError
import logging

logger = logging.getLogger(__name__)

# Import database components
from app.core.database import engine, Base
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

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "http://localhost:3001"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(links.router, prefix="/api/links", tags=["links"])
app.include_router(analytics.router, prefix="/api/analytics", tags=["analytics"])
app.include_router(tracking.router, prefix="/r", tags=["tracking"])


@app.get("/")
async def root():
    return {
        "message": "Link Tracking System API",
        "version": "1.0.0",
        "docs": "/docs"
    }


@app.get("/health")
async def health_check():
    return {"status": "healthy"}
