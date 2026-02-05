@echo off
echo ========================================
echo Teste de Conexao com Banco de Dados
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
python -c "from app.core.database import engine; from sqlalchemy import text; conn = engine.connect(); result = conn.execute(text('SELECT version()')); print('[OK] Conexao estabelecida!'); print('Versao PostgreSQL:', result.scalar()); conn.close()"

if errorlevel 1 (
    echo.
    echo [ERRO] Falha ao conectar ao banco de dados!
    echo.
    echo Verifique:
    echo   1. Credenciais no arquivo backend/.env
    echo   2. Se o servidor PostgreSQL esta acessivel
    echo   3. Se a porta e host estao corretos
    echo   4. Se o firewall permite a conexao
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
