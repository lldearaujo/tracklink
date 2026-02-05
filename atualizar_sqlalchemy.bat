@echo off
echo ========================================
echo Atualizando SQLAlchemy para versao compativel com Python 3.13
echo ========================================
echo.

if not exist venv (
    echo ERRO: Ambiente virtual nao encontrado!
    echo Execute setup.bat primeiro.
    pause
    exit /b 1
)

echo Ativando ambiente virtual...
call venv\Scripts\activate.bat

echo.
echo Desinstalando SQLAlchemy antigo...
venv\Scripts\pip.exe uninstall -y sqlalchemy

echo.
echo Instalando SQLAlchemy atualizado (compativel com Python 3.13)...
venv\Scripts\pip.exe install --no-cache-dir --upgrade "sqlalchemy>=2.0.36"

if errorlevel 1 (
    echo.
    echo ERRO: Falha ao atualizar SQLAlchemy!
    echo.
    echo Tentando versao mais recente...
    venv\Scripts\pip.exe install --no-cache-dir --upgrade sqlalchemy
    if errorlevel 1 (
        echo.
        echo ERRO: Falha ao instalar SQLAlchemy!
        pause
        exit /b 1
    )
)

echo.
echo Verificando instalacao...
venv\Scripts\python.exe -c "import sqlalchemy; print('[OK] SQLAlchemy', sqlalchemy.__version__, 'instalado!')"

if errorlevel 1 (
    echo [ERRO] Falha ao importar SQLAlchemy
    pause
    exit /b 1
)

echo.
echo ========================================
echo [SUCESSO] SQLAlchemy atualizado!
echo ========================================
echo.
echo Agora voce pode iniciar o backend:
echo   start_backend.bat
echo.
pause
