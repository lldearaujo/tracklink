s@echo off
echo ========================================
echo Instalacao do psycopg2-binary para Windows
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
echo Instalando psycopg2-binary (versao mais recente com wheels pre-compilados)...
echo.

REM Tentar instalar versao mais recente que tem wheels
venv\Scripts\pip.exe install --upgrade pip
venv\Scripts\pip.exe install --no-cache-dir psycopg2-binary

if errorlevel 1 (
    echo.
    echo ========================================
    echo ERRO na instalacao do psycopg2-binary
    echo ========================================
    echo.
    echo Tentando alternativa: instalar sem cache...
    venv\Scripts\pip.exe install --no-cache-dir --force-reinstall psycopg2-binary
    
    if errorlevel 1 (
        echo.
        echo ========================================
        echo Solucao Alternativa
        echo ========================================
        echo.
        echo Se o erro persistir, tente:
        echo.
        echo 1. Instalar Microsoft Visual C++ Build Tools:
        echo    https://visualstudio.microsoft.com/visual-cpp-build-tools/
        echo.
        echo 2. Ou usar uma versao especifica que funciona:
        echo    pip install psycopg2-binary==2.9.8
        echo.
        echo 3. Ou instalar PostgreSQL client tools:
        echo    https://www.postgresql.org/download/windows/
        echo.
        pause
        exit /b 1
    )
)

echo.
echo ========================================
echo [SUCESSO] psycopg2-binary instalado!
echo ========================================
echo.
echo Testando importacao...
venv\Scripts\python.exe -c "import psycopg2; print('[OK] psycopg2 importado com sucesso!')"

if errorlevel 1 (
    echo [ERRO] Falha ao importar psycopg2
    pause
    exit /b 1
)

echo.
echo Agora voce pode continuar com: setup.bat
echo Ou instalar as outras dependencias: pip install -r requirements.txt
echo.
pause
