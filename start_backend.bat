@echo off
echo ========================================
echo Iniciando Backend - Link Tracking API
echo ========================================
echo.

if not exist venv (
    echo ERRO: Ambiente virtual nao encontrado!
    echo Execute setup.bat primeiro para configurar o ambiente.
    pause
    exit /b 1
)

echo Ativando ambiente virtual...
call venv\Scripts\activate.bat

echo.
echo Iniciando servidor na porta 8000...
echo Backend: http://localhost:8000
echo API Docs: http://localhost:8000/docs
echo.
echo Pressione Ctrl+C para parar o servidor
echo.

cd backend
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
pause
