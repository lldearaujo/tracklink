@echo off
echo ========================================
echo Verificacao do Ambiente
echo ========================================
echo.

echo [1] Verificando Python...
set PYTHON_CMD=
python --version >nul 2>&1
if not errorlevel 1 (
    set PYTHON_CMD=python
    goto :check_python_ok
)

py --version >nul 2>&1
if not errorlevel 1 (
    set PYTHON_CMD=py
    goto :check_python_ok
)

python3 --version >nul 2>&1
if not errorlevel 1 (
    set PYTHON_CMD=python3
    goto :check_python_ok
)

echo [X] Python NAO encontrado
echo     Execute verificar_python.bat para diagnostico completo
echo     Instale Python 3.11+ de: https://www.python.org/downloads/
goto :check_python_end

:check_python_ok
for /f "tokens=2" %%v in ('%PYTHON_CMD% --version 2^>^&1') do set PYTHON_VERSION=%%v
echo [OK] Python encontrado usando: %PYTHON_CMD%
echo     Versao: %PYTHON_VERSION%
%PYTHON_CMD% --version

:check_python_end
echo.

echo [2] Verificando Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo [X] Node.js NAO encontrado
    echo     Instale Node.js 18+ de: https://nodejs.org/
) else (
    node --version
    echo [OK] Node.js encontrado
)
echo.

echo [3] Verificando ambiente virtual...
if exist venv (
    echo [OK] Ambiente virtual existe
) else (
    echo [X] Ambiente virtual NAO encontrado
    echo     Execute: setup.bat
)
echo.

echo [4] Verificando dependencias Python...
if exist venv\Scripts\python.exe (
    call venv\Scripts\activate.bat
    pip show fastapi >nul 2>&1
    if errorlevel 1 (
        echo [X] Dependencias Python NAO instaladas
        echo     Execute: setup.bat
    ) else (
        echo [OK] Dependencias Python instaladas
    )
) else (
    echo [X] Ambiente virtual nao configurado
)
echo.

echo [5] Verificando dependencias Frontend...
if exist frontend\node_modules (
    echo [OK] Dependencias Frontend instaladas
) else (
    echo [X] Dependencias Frontend NAO instaladas
    echo     Execute: setup.bat
)
echo.

echo ========================================
echo Verificacao concluida!
echo ========================================
echo.
pause
