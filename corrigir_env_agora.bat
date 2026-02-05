@echo off
echo ========================================
echo Corrigindo arquivo .env com senha correta
echo ========================================
echo.

cd backend

echo Criando arquivo .env com formato correto...
echo Senha: S3v3r1n0_o1
echo.

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

echo [OK] Arquivo .env criado/atualizado!
echo.
echo Testando conexao...
cd ..

if not exist venv (
    echo AVISO: Ambiente virtual nao encontrado. Pulando teste.
    pause
    exit /b 0
)

call venv\Scripts\activate.bat
cd backend
python -c "from app.core.database import engine; from sqlalchemy import text; conn = engine.connect(); result = conn.execute(text('SELECT version()')); print('[OK] Conexao estabelecida!'); print('Versao PostgreSQL:', result.scalar()); conn.close()"

if errorlevel 1 (
    echo.
    echo [AVISO] Falha ao testar conexao, mas arquivo .env foi criado.
    echo Verifique se o backend esta rodando e se vai reconectar automaticamente.
) else (
    echo.
    echo ========================================
    echo [SUCESSO] Tudo configurado!
    echo ========================================
    echo.
    echo O backend vai reconectar automaticamente ^(reload ativo^)
    echo.
)

cd ..
pause
