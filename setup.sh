#!/bin/bash

echo "========================================"
echo "Configuracao do Ambiente Local"
echo "========================================"
echo ""

echo "[1/4] Verificando Python..."
if ! command -v python3 &> /dev/null; then
    echo "ERRO: Python nao encontrado! Por favor, instale Python 3.11 ou superior."
    exit 1
fi
python3 --version
echo ""

echo "[2/4] Criando ambiente virtual Python..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo "Ambiente virtual criado!"
else
    echo "Ambiente virtual ja existe."
fi
echo ""

echo "[3/4] Instalando dependencias Python..."
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "ERRO: Falha ao instalar dependencias Python!"
    exit 1
fi
echo "Dependencias Python instaladas!"
echo ""

echo "[4/4] Verificando Node.js..."
if ! command -v node &> /dev/null; then
    echo "AVISO: Node.js nao encontrado! O frontend nao funcionara sem Node.js."
    echo "Por favor, instale Node.js 18 ou superior."
    exit 1
fi
node --version
echo ""

echo "[5/5] Instalando dependencias do Frontend..."
cd frontend
if [ ! -d "node_modules" ]; then
    npm install
    if [ $? -ne 0 ]; then
        echo "ERRO: Falha ao instalar dependencias do frontend!"
        cd ..
        exit 1
    fi
    echo "Dependencias do frontend instaladas!"
else
    echo "Dependencias do frontend ja instaladas."
fi
cd ..
echo ""

echo "========================================"
echo "Configuracao concluida com sucesso!"
echo "========================================"
echo ""
echo "Para iniciar o sistema:"
echo "  1. Execute ./start_backend.sh (em um terminal)"
echo "  2. Execute ./start_frontend.sh (em outro terminal)"
echo ""
echo "Ou execute ./start_all.sh para iniciar ambos automaticamente."
echo ""
