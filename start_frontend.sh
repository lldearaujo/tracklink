#!/bin/bash

echo "========================================"
echo "Iniciando Frontend - Link Tracking Dashboard"
echo "========================================"
echo ""

if [ ! -d "frontend/node_modules" ]; then
    echo "AVISO: Dependencias do frontend nao encontradas!"
    echo "Instalando dependencias..."
    cd frontend
    npm install
    if [ $? -ne 0 ]; then
        echo "ERRO: Falha ao instalar dependencias!"
        exit 1
    fi
    cd ..
fi

echo ""
echo "Iniciando servidor na porta 3000..."
echo "Frontend: http://localhost:3000"
echo ""
echo "Pressione Ctrl+C para parar o servidor"
echo ""

cd frontend
npm start
