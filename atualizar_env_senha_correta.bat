@echo off
echo ========================================
echo Atualizando .env com Senha Correta
echo ========================================
echo.

echo A senha correta encontrada foi: S3v3r1n0_o1
echo.
echo Atualizando arquivo backend\.env...
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
echo # CORS Origins - formato JSON array
echo CORS_ORIGINS=["http://localhost:3000","http://localhost:3001"]
) > .env

if errorlevel 1 (
    echo ERRO: Falha ao criar arquivo .env!
    cd ..
    pause
    exit /b 1
)

echo [OK] Arquivo .env atualizado com sucesso!
echo.
echo Testando conexao...
venv\Scripts\python.exe -c "from app.core.database import engine; from sqlalchemy import text; conn = engine.connect(); result = conn.execute(text('SELECT version()')); print('[OK] Conexao estabelecida!'); print('Versao PostgreSQL:', result.scalar()); conn.close()"

if errorlevel 1 (
    echo.
    echo [ERRO] Falha ao conectar. Verifique manualmente.
) else (
    echo.
    echo ========================================
    echo [SUCESSO] Banco de dados conectado!
    echo ========================================
    echo.
    echo O backend vai reconectar automaticamente ^(reload ativo^)
    echo.
)

cd ..
pause
