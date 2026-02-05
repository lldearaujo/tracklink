@echo off
echo ========================================
echo Diagnostico Completo do Banco de Dados
echo ========================================
echo.

if not exist venv (
    echo ERRO: Ambiente virtual nao encontrado!
    pause
    exit /b 1
)

call venv\Scripts\activate.bat

echo.
echo [1/4] Testando conexao basica...
echo.

cd backend
python -c "import psycopg2; print('[OK] psycopg2 importado')" 2>nul
if errorlevel 1 (
    echo [ERRO] psycopg2 nao esta instalado!
    cd ..
    pause
    exit /b 1
)

echo.
echo [2/4] Testando diferentes formatos de URL...
echo.

REM Testar URL externa
echo Testando URL Externa (72.60.63.29:32541)...
python -c "import psycopg2; conn = psycopg2.connect(host='72.60.63.29', port=32541, user='tracking', password='S3v3r1n0_01', database='bd_tracking'); print('[OK] Conexao externa funcionou!'); conn.close()" 2>nul
if not errorlevel 1 (
    echo [SUCESSO] URL Externa funciona!
    set URL_FUNCIONA=EXTERNA
    goto :testar_interna
)

echo [FALHOU] URL Externa nao funcionou
echo.

REM Testar URL interna
:testar_interna
echo Testando URL Interna (outdoora_bd_tracking:5432)...
python -c "import psycopg2; conn = psycopg2.connect(host='outdoora_bd_tracking', port=5432, user='tracking', password='S3v3r1n0_01', database='bd_tracking'); print('[OK] Conexao interna funcionou!'); conn.close()" 2>nul
if not errorlevel 1 (
    echo [SUCESSO] URL Interna funciona!
    set URL_FUNCIONA=INTERNA
    goto :testar_senha_alternativa
)

echo [FALHOU] URL Interna nao funcionou
echo.

REM Testar senha alternativa
:testar_senha_alternativa
echo.
echo [3/4] Testando senha alternativa (S3v3r1n0_o1)...
echo.

echo Testando URL Externa com senha alternativa...
python -c "import psycopg2; conn = psycopg2.connect(host='72.60.63.29', port=32541, user='tracking', password='S3v3r1n0_o1', database='bd_tracking'); print('[OK] Conexao com senha alternativa funcionou!'); conn.close()" 2>nul
if not errorlevel 1 (
    echo [SUCESSO] Senha alternativa funciona!
    set SENHA_CORRETA=S3v3r1n0_o1
    set URL_FUNCIONA=EXTERNA
    goto :corrigir_config
)

echo [FALHOU] Senha alternativa nao funcionou
echo.

REM Testar conectividade basica
echo.
echo [4/4] Testando conectividade de rede...
echo.

echo Testando se o servidor esta acessivel...
ping -n 1 72.60.63.29 >nul 2>&1
if errorlevel 1 (
    echo [AVISO] Nao foi possivel fazer ping no servidor
    echo Isso pode indicar problema de rede ou firewall
) else (
    echo [OK] Servidor esta acessivel via ping
)

echo.
echo ========================================
echo Resumo do Diagnostico:
echo ========================================
echo.

if defined URL_FUNCIONA (
    echo [SUCESSO] Encontrada conexao funcionando!
    echo URL: %URL_FUNCIONA%
    if defined SENHA_CORRETA (
        echo Senha: %SENHA_CORRETA%
    ) else (
        echo Senha: S3v3r1n0_01
    )
    echo.
    choice /C SN /M "Deseja atualizar o arquivo .env com essas credenciais"
    if errorlevel 2 goto :fim
    if errorlevel 1 goto :corrigir_config
) else (
    echo [ERRO] Nenhuma conexao funcionou!
    echo.
    echo Possiveis causas:
    echo   1. Firewall bloqueando a conexao
    echo   2. Servidor PostgreSQL nao esta acessivel
    echo   3. Credenciais realmente incorretas
    echo   4. Usuario nao tem permissao de acesso remoto
    echo   5. Servidor nao aceita conexoes externas
    echo.
    echo Solucoes:
    echo   - Verifique com o administrador do banco
    echo   - Teste com um cliente PostgreSQL (pgAdmin, DBeaver)
    echo   - Verifique se o firewall permite conexoes na porta 32541
)

goto :fim

:corrigir_config
echo.
echo Atualizando arquivo backend\.env...

if "%URL_FUNCIONA%"=="EXTERNA" (
    if defined SENHA_CORRETA (
        set URL=postgresql://tracking:%SENHA_CORRETA%@72.60.63.29:32541/bd_tracking?sslmode=disable
    ) else (
        set URL=postgresql://tracking:S3v3r1n0_01@72.60.63.29:32541/bd_tracking?sslmode=disable
    )
) else (
    if defined SENHA_CORRETA (
        set URL=postgresql://tracking:%SENHA_CORRETA%@outdoora_bd_tracking:5432/bd_tracking?sslmode=disable
    ) else (
        set URL=postgresql://tracking:S3v3r1n0_01@outdoora_bd_tracking:5432/bd_tracking?sslmode=disable
    )
)

(
echo # Database Configuration - PostgreSQL
echo DATABASE_URL=%URL%
echo.
echo # API Configuration
echo SECRET_KEY=link-tracking-system-secret-key-2024
echo.
echo # CORS Origins - formato JSON array
echo CORS_ORIGINS=["http://localhost:3000","http://localhost:3001"]
) > .env

echo [OK] Arquivo .env atualizado!
echo.
echo Testando conexao com nova configuracao...
python -c "from app.core.database import engine; from sqlalchemy import text; conn = engine.connect(); result = conn.execute(text('SELECT version()')); print('[OK] Conexao estabelecida!'); print('Versao:', result.scalar()); conn.close()"

if errorlevel 1 (
    echo [ERRO] Ainda nao funcionou. Verifique manualmente.
) else (
    echo.
    echo ========================================
    echo [SUCESSO] Banco de dados configurado!
    echo ========================================
    echo.
    echo Reinicie o backend para aplicar as mudancas.
)

:fim
cd ..
echo.
pause
