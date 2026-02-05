@echo off
echo ========================================
echo Configuracao do Banco de Dados
echo ========================================
echo.

if exist backend\.env (
    echo Arquivo .env ja existe!
    echo.
    choice /C SN /M "Deseja sobrescrever"
    if errorlevel 2 goto :end
    if errorlevel 1 goto :create
) else (
    goto :create
)

:create
echo Criando arquivo backend\.env com as credenciais do PostgreSQL...
echo.

(
echo # Database Configuration - PostgreSQL
echo # External connection URL ^(for local development^)
echo DATABASE_URL=postgresql://tracking:S3v3r1n0_01@72.60.63.29:32541/bd_tracking?sslmode=disable
echo.
echo # Alternative: Internal URL ^(if running on same network^)
echo # DATABASE_URL=postgresql://tracking:S3v3r1n0_01@outdoora_bd_tracking:5432/bd_tracking?sslmode=disable
echo.
echo # API Configuration
echo SECRET_KEY=link-tracking-system-secret-key-2024
echo.
echo # CORS Origins - formato JSON array
echo CORS_ORIGINS=["http://localhost:3000","http://localhost:3001"]
echo.
echo # GeoIP Configuration ^(optional^)
echo GEOIP_ENABLED=false
echo GEOIP_DB_PATH=
) > backend\.env

if errorlevel 1 (
    echo ERRO: Falha ao criar arquivo .env!
    pause
    exit /b 1
)

echo [OK] Arquivo backend\.env criado com sucesso!
echo.
echo Credenciais configuradas:
echo   Host: 72.60.63.29
echo   Porta: 32541
echo   Usuario: tracking
echo   Banco: bd_tracking
echo.
echo Para testar a conexao, execute: testar_conexao_db.bat
echo.

:end
pause
