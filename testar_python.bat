@echo off
echo ========================================
echo Teste Rapido do Python
echo ========================================
echo.

echo Verificando instalacao do Python...
python --version
if errorlevel 1 (
    echo.
    echo [ERRO] Python nao encontrado no PATH!
    echo.
    echo Solucoes:
    echo 1. Certifique-se de que Python esta instalado
    echo 2. Adicione Python ao PATH do sistema
    echo 3. Tente usar: py --version (Python Launcher)
    echo.
    pause
    exit /b 1
)

echo.
echo Testando importacao de modulos essenciais...
%PYTHON_CMD% -c "import sys; print('Python:', sys.version)"
%PYTHON_CMD% -c "import sqlite3; print('[OK] sqlite3 disponivel')"
%PYTHON_CMD% -c "import json; print('[OK] json disponivel')"

echo.
echo ========================================
echo Python esta funcionando corretamente!
echo ========================================
echo.
echo Voce pode prosseguir com: setup.bat
echo.
pause
