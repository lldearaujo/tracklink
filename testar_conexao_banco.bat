@echo off
echo ========================================
echo Teste de Conexao com Banco de Dados PostgreSQL
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
echo Testando conexao com PostgreSQL...
echo.

cd backend
venv\Scripts\python.exe -c "from app.core.database import engine; from sqlalchemy import text; conn = engine.connect(); result = conn.execute(text('SELECT version()')); print('[OK] Conexao estabelecida!'); print('Versao PostgreSQL:', result.scalar()); conn.close()"

if errorlevel 1 (
    echo.
    echo ========================================
    echo [ERRO] Falha ao conectar ao banco de dados!
    echo ========================================
    echo.
    echo Possiveis causas:
    echo   1. Senha incorreta
    echo   2. Usuario nao existe ou nao tem permissao
    echo   3. Servidor PostgreSQL nao esta acessivel
    echo   4. Firewall bloqueando a conexao
    echo   5. Credenciais incorretas no arquivo backend\.env
    echo.
    echo Verifique o arquivo backend\.env e confirme:
    echo   - Host: 72.60.63.29
    echo   - Porta: 32541
    echo   - Usuario: tracking
    echo   - Senha: S3v3r1n0_01
    echo   - Banco: bd_tracking
    echo.
    echo Nota: A senha na URL deve ser URL-encoded se tiver caracteres especiais
    echo.
    cd ..
    pause
    exit /b 1
)

echo.
echo ========================================
echo [SUCESSO] Banco de dados conectado!
echo ========================================
echo.
cd ..
pause
