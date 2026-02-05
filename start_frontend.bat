@echo off
echo ========================================
echo Iniciando Frontend - Link Tracking Dashboard
echo ========================================
echo.

if not exist frontend\node_modules (
    echo AVISO: Dependencias do frontend nao encontradas!
    echo Instalando dependencias...
    cd frontend
    call npm install
    if errorlevel 1 (
        echo ERRO: Falha ao instalar dependencias!
        cd ..
        pause
        exit /b 1
    )
    cd ..
)

echo.
echo Iniciando servidor na porta 3000...
echo Frontend: http://localhost:3000
echo.
echo Pressione Ctrl+C para parar o servidor
echo.

cd frontend
npm start
pause
