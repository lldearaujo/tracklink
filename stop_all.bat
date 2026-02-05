@echo off
echo ========================================
echo Parando todos os servidores
echo ========================================
echo.

echo [1/2] Encerrando Frontend (Node.js)...
taskkill /F /IM node.exe >nul 2>&1
if errorlevel 1 (
    echo   Nenhum processo Node.js encontrado
) else (
    echo   [OK] Frontend encerrado
)
echo.

echo [2/2] Encerrando Backend (Python/Uvicorn)...
REM Encerrar processos uvicorn especificamente
wmic process where "name='python.exe' and commandline like '%%uvicorn%%'" delete >nul 2>&1
if errorlevel 1 (
    echo   Nenhum processo uvicorn encontrado
) else (
    echo   [OK] Backend encerrado
)
echo.

REM Tambem tentar encerrar qualquer python.exe relacionado ao uvicorn
for /f "tokens=2" %%a in ('tasklist /FI "IMAGENAME eq python.exe" /FO LIST ^| findstr /i "PID"') do (
    set PID=%%a
    set PID=!PID:PID:=!
    wmic process where "ProcessId=!PID!" get CommandLine 2>nul | findstr /i "uvicorn" >nul
    if not errorlevel 1 (
        taskkill /F /PID !PID! >nul 2>&1
    )
)

echo ========================================
echo Servidores encerrados!
echo ========================================
echo.
pause
