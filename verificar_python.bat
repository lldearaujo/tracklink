@echo off
echo ========================================
echo Verificacao Detalhada do Python
echo ========================================
echo.

echo Testando diferentes comandos Python...
echo.

echo [1] Testando: python
python --version >nul 2>&1
if errorlevel 1 (
    echo    [X] python - NAO encontrado
) else (
    echo    [OK] python - ENCONTRADO
    python --version
    where python
)
echo.

echo [2] Testando: py
py --version >nul 2>&1
if errorlevel 1 (
    echo    [X] py - NAO encontrado
) else (
    echo    [OK] py - ENCONTRADO
    py --version
    where py
)
echo.

echo [3] Testando: python3
python3 --version >nul 2>&1
if errorlevel 1 (
    echo    [X] python3 - NAO encontrado
) else (
    echo    [OK] python3 - ENCONTRADO
    python3 --version
    where python3
)
echo.

echo ========================================
echo Verificando PATH do sistema...
echo ========================================
echo.
echo PATH atual:
echo %PATH%
echo.

echo ========================================
echo Verificando instalacoes Python comuns...
echo ========================================
echo.

if exist "C:\Python*" (
    echo Encontrado em: C:\Python*
    dir /b C:\Python* 2>nul
) else (
    echo Nao encontrado em: C:\Python*
)
echo.

if exist "%LOCALAPPDATA%\Programs\Python" (
    echo Encontrado em: %LOCALAPPDATA%\Programs\Python
    dir /b "%LOCALAPPDATA%\Programs\Python" 2>nul
) else (
    echo Nao encontrado em: %LOCALAPPDATA%\Programs\Python
)
echo.

if exist "%ProgramFiles%\Python*" (
    echo Encontrado em: %ProgramFiles%\Python*
    dir /b "%ProgramFiles%\Python*" 2>nul
) else (
    echo Nao encontrado em: %ProgramFiles%\Python*
)
echo.

echo ========================================
echo Recomendacoes:
echo ========================================
echo.
echo Se Python nao foi encontrado:
echo   1. Instale Python de: https://www.python.org/downloads/
echo   2. Durante a instalacao, marque "Add Python to PATH"
echo   3. Reinicie o terminal apos instalar
echo.
echo Se Python esta instalado mas nao encontrado:
echo   1. Adicione Python manualmente ao PATH
echo   2. Ou use o Python Launcher: py --version
echo   3. Reinicie o terminal
echo.
pause
