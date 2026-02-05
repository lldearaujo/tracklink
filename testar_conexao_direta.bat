@echo off
echo ========================================
echo Teste Direto de Conexao PostgreSQL
echo ========================================
echo.

if not exist venv (
    echo ERRO: Ambiente virtual nao encontrado!
    pause
    exit /b 1
)

call venv\Scripts\activate.bat

echo.
echo Testando conexao direta com psycopg2...
echo.

cd backend

echo Teste 1: URL Externa com senha S3v3r1n0_01
python -c "import psycopg2; conn = psycopg2.connect(host='72.60.63.29', port=32541, user='tracking', password='S3v3r1n0_01', database='bd_tracking', connect_timeout=10); print('[OK] Conexao estabelecida!'); cur = conn.cursor(); cur.execute('SELECT version()'); print('PostgreSQL:', cur.fetchone()[0]); conn.close()" 2>&1

if not errorlevel 1 (
    echo.
    echo [SUCESSO] Esta configuracao funciona!
    echo Use: postgresql://tracking:S3v3r1n0_01@72.60.63.29:32541/bd_tracking?sslmode=disable
    cd ..
    pause
    exit /b 0
)

echo.
echo Teste 2: URL Externa com senha S3v3r1n0_o1
python -c "import psycopg2; conn = psycopg2.connect(host='72.60.63.29', port=32541, user='tracking', password='S3v3r1n0_o1', database='bd_tracking', connect_timeout=10); print('[OK] Conexao estabelecida!'); cur = conn.cursor(); cur.execute('SELECT version()'); print('PostgreSQL:', cur.fetchone()[0]); conn.close()" 2>&1

if not errorlevel 1 (
    echo.
    echo [SUCESSO] Esta configuracao funciona!
    echo Use: postgresql://tracking:S3v3r1n0_o1@72.60.63.29:32541/bd_tracking?sslmode=disable
    cd ..
    pause
    exit /b 0
)

echo.
echo Teste 3: URL Interna com senha S3v3r1n0_01
python -c "import psycopg2; conn = psycopg2.connect(host='outdoora_bd_tracking', port=5432, user='tracking', password='S3v3r1n0_01', database='bd_tracking', connect_timeout=10); print('[OK] Conexao estabelecida!'); cur = conn.cursor(); cur.execute('SELECT version()'); print('PostgreSQL:', cur.fetchone()[0]); conn.close()" 2>&1

if not errorlevel 1 (
    echo.
    echo [SUCESSO] Esta configuracao funciona!
    echo Use: postgresql://tracking:S3v3r1n0_01@outdoora_bd_tracking:5432/bd_tracking?sslmode=disable
    cd ..
    pause
    exit /b 0
)

echo.
echo ========================================
echo [ERRO] Nenhuma conexao funcionou!
echo ========================================
echo.
echo Possiveis problemas:
echo   1. Firewall bloqueando porta 32541
echo   2. Servidor PostgreSQL nao aceita conexoes externas
echo   3. IP nao esta na whitelist do PostgreSQL
echo   4. Servidor esta offline
echo   5. Credenciais realmente incorretas
echo.
echo Solucoes:
echo   - Verifique com o administrador do banco
echo   - Teste de outra maquina/rede
echo   - Use um cliente PostgreSQL (pgAdmin, DBeaver)
echo   - Verifique se precisa de VPN ou tunel SSH
echo.

cd ..
pause
