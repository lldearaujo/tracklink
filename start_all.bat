@echo off
echo ========================================
echo Iniciando Sistema de Rastreamento de Links
echo ========================================
echo.

REM Verificar ambiente virtual
if not exist venv (
    echo ERRO: Ambiente virtual nao encontrado!
    echo Execute setup.bat primeiro para configurar o ambiente.
    pause
    exit /b 1
)

REM Verificar dependencias do frontend
if not exist frontend\node_modules (
    echo AVISO: Dependencias do frontend nao encontradas!
    echo Instalando dependencias do frontend...
    cd frontend
    call npm install
    if errorlevel 1 (
        echo ERRO: Falha ao instalar dependencias do frontend!
        cd ..
        pause
        exit /b 1
    )
    cd ..
)

echo.
echo ========================================
echo Iniciando Backend (porta 8000)...
echo ========================================
echo.

REM Ativar ambiente virtual
call venv\Scripts\activate.bat

REM Iniciar backend em background
cd backend
start /b python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
cd ..

echo [OK] Backend iniciado em background
echo Aguardando backend inicializar...
timeout /t 5 /nobreak >nul

echo.
echo ========================================
echo Iniciando Frontend (porta 3000)...
echo ========================================
echo.

REM Iniciar frontend em background
cd frontend
start /b npm start
cd ..

echo [OK] Frontend iniciado em background
echo.

echo ========================================
echo Sistema iniciado com sucesso!
echo ========================================
echo.
echo Acesse:
echo   Dashboard: http://localhost:3000
echo   API Docs:  http://localhost:8000/docs
echo   Backend:   http://localhost:8000
echo.
echo ========================================
echo IMPORTANTE:
echo ========================================
echo - Backend e Frontend estao rodando em background
echo - Para parar, execute: stop_all.bat
echo - Ou pressione Ctrl+C e confirme
echo.
echo Pressione qualquer tecla para manter o terminal aberto...
echo (Os servidores continuarao rodando em background)
pause
