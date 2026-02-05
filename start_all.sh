#!/bin/bash

echo "========================================"
echo "Iniciando Sistema de Rastreamento de Links"
echo "========================================"
echo ""

if [ ! -d "venv" ]; then
    echo "ERRO: Ambiente virtual nao encontrado!"
    echo "Execute ./setup.sh primeiro para configurar o ambiente."
    exit 1
fi

echo "Ativando ambiente virtual..."
source venv/bin/activate

echo ""
echo "Iniciando Backend (porta 8000)..."
cd backend
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000 &
BACKEND_PID=$!
cd ..

echo "Aguardando backend iniciar..."
sleep 3

echo ""
echo "Iniciando Frontend (porta 3000)..."
cd frontend
npm start &
FRONTEND_PID=$!
cd ..

echo ""
echo "========================================"
echo "Sistema iniciado!"
echo "========================================"
echo ""
echo "Backend: http://localhost:8000"
echo "Frontend: http://localhost:3000"
echo "API Docs: http://localhost:8000/docs"
echo ""
echo "PIDs: Backend=$BACKEND_PID, Frontend=$FRONTEND_PID"
echo "Para parar, execute: kill $BACKEND_PID $FRONTEND_PID"
echo ""
echo "Pressione Ctrl+C para parar..."
wait
