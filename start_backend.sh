#!/bin/bash

echo "========================================"
echo "Iniciando Backend - Link Tracking API"
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
echo "Iniciando servidor na porta 8000..."
echo "Backend: http://localhost:8000"
echo "API Docs: http://localhost:8000/docs"
echo ""
echo "Pressione Ctrl+C para parar o servidor"
echo ""

cd backend
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
