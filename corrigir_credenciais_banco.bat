@echo off
echo ========================================
echo Corrigir Credenciais do Banco de Dados
echo ========================================
echo.

if not exist venv (
    echo ERRO: Ambiente virtual nao encontrado!
    pause
    exit /b 1
)

call venv\Scripts\activate.bat

echo.
echo Credenciais atuais configuradas:
echo.
cd backend
python -c "from app.core.config import settings; url = settings.DATABASE_URL; parts = url.split('@'); if len(parts) > 0: user_pass = parts[0].split('://')[1]; user = user_pass.split(':')[0]; print('Usuario:', user); print('Host:', parts[1].split('/')[0] if len(parts) > 1 else 'N/A')"
cd ..

echo.
echo ========================================
echo Opcoes:
echo ========================================
echo.
echo 1. Testar conexao atual
echo 2. Editar arquivo .env manualmente
echo 3. Criar arquivo .env com credenciais padrao
echo 4. Ver conteudo do arquivo .env atual
echo.
choice /C 1234 /M "Escolha uma opcao"

if errorlevel 4 goto :ver_env
if errorlevel 3 goto :criar_env
if errorlevel 2 goto :editar_env
if errorlevel 1 goto :testar

:testar
echo.
echo Testando conexao...
call testar_conexao_banco.bat
goto :end

:editar_env
echo.
echo Abrindo arquivo backend\.env para edicao...
if exist backend\.env (
    notepad backend\.env
) else (
    echo Arquivo backend\.env nao existe!
    echo Criando arquivo...
    goto :criar_env
)
goto :end

:ver_env
echo.
echo ========================================
echo Conteudo do arquivo backend\.env:
echo ========================================
echo.
if exist backend\.env (
    type backend\.env
) else (
    echo Arquivo backend\.env nao existe!
)
echo.
pause
goto :end

:criar_env
echo.
echo Criando arquivo backend\.env...
echo.
echo IMPORTANTE: Verifique a senha correta!
echo.
echo Baseado na imagem fornecida:
echo   Senha mostrada: S3v3r1n0_01
echo   URL interna mostra: S3v3r1n0_o1 (com o minusculo)
echo.
choice /C SN /M "Usar senha S3v3r1n0_01 (S) ou S3v3r1n0_o1 (N)"

if errorlevel 2 (
    set SENHA=S3v3r1n0_o1
) else (
    set SENHA=S3v3r1n0_01
)

(
echo # Database Configuration - PostgreSQL
echo DATABASE_URL=postgresql://tracking:%SENHA%@72.60.63.29:32541/bd_tracking?sslmode=disable
echo.
echo # Alternative: Internal URL ^(if running on same network^)
echo # DATABASE_URL=postgresql://tracking:%SENHA%@outdoora_bd_tracking:5432/bd_tracking?sslmode=disable
echo.
echo # API Configuration
echo SECRET_KEY=link-tracking-system-secret-key-2024
echo.
echo # CORS Origins - formato JSON array
echo CORS_ORIGINS=["http://localhost:3000","http://localhost:3001"]
) > backend\.env

echo.
echo [OK] Arquivo backend\.env criado com senha: %SENHA%
echo.
echo Testando conexao...
timeout /t 2 /nobreak >nul
call testar_conexao_banco.bat
goto :end

:end
echo.
pause
