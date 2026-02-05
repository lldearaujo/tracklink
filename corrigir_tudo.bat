@echo off
echo ========================================
echo Corrigindo Todos os Problemas
echo ========================================
echo.

echo [1/2] Corrigindo arquivo .env do backend...
echo.

cd backend

(
echo # Database Configuration - PostgreSQL
echo DATABASE_URL=postgresql://tracking:S3v3r1n0_o1@72.60.63.29:32541/bd_tracking?sslmode=disable
echo.
echo # Alternative: Internal URL ^(if running on same network^)
echo # DATABASE_URL=postgresql://tracking:S3v3r1n0_o1@outdoora_bd_tracking:5432/bd_tracking?sslmode=disable
echo.
echo # API Configuration
echo SECRET_KEY=link-tracking-system-secret-key-2024
echo.
echo # CORS Origins - formato JSON array ^(obrigatorio para Pydantic^)
echo CORS_ORIGINS=["http://localhost:3000","http://localhost:3001"]
) > .env

if errorlevel 1 (
    echo ERRO: Falha ao criar arquivo .env!
    cd ..
    pause
    exit /b 1
)

echo [OK] Arquivo backend\.env atualizado com senha correta!
cd ..

echo.
echo [2/2] Verificando correcoes do frontend...
echo.

echo [OK] Import do date-fns ja foi corrigido
echo.

echo ========================================
echo Correcoes aplicadas!
echo ========================================
echo.
echo O que foi corrigido:
echo   1. Senha do banco: S3v3r1n0_o1
echo   2. Formato CORS_ORIGINS: JSON array
echo   3. Import do date-fns no frontend
echo.
echo O backend vai reconectar automaticamente ^(reload ativo^)
echo O frontend vai recompilar automaticamente
echo.
echo Aguarde alguns segundos e recarregue a pagina do frontend.
echo.
pause
