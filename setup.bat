@echo off
echo ========================================
echo Configuracao do Ambiente Local
echo ========================================
echo.

echo [1/4] Verificando Python...
echo Tentando detectar Python...

REM Tentar diferentes comandos Python
set PYTHON_CMD=
python --version >nul 2>&1
if not errorlevel 1 (
    set PYTHON_CMD=python
    goto :python_found
)

py --version >nul 2>&1
if not errorlevel 1 (
    set PYTHON_CMD=py
    goto :python_found
)

python3 --version >nul 2>&1
if not errorlevel 1 (
    set PYTHON_CMD=python3
    goto :python_found
)

REM Python nao encontrado
echo.
echo ========================================
echo ERRO: Python nao encontrado!
echo ========================================
echo.
echo Tentamos os seguintes comandos:
echo   - python
echo   - py
echo   - python3
echo.
echo Solucoes possiveis:
echo   1. Certifique-se de que Python esta instalado
echo   2. Adicione Python ao PATH do sistema
echo   3. Tente executar manualmente: python --version
echo   4. Se Python esta instalado, reinicie o terminal
echo.
echo Para instalar Python:
echo   https://www.python.org/downloads/
echo.
echo Apos instalar, certifique-se de marcar:
echo   "Add Python to PATH" durante a instalacao
echo.
pause
exit /b 1

:python_found
echo [OK] Python encontrado usando: %PYTHON_CMD%
%PYTHON_CMD% --version
echo.

echo [2/4] Criando ambiente virtual Python...
if not exist venv (
    echo Criando novo ambiente virtual...
    %PYTHON_CMD% -m venv venv
    if errorlevel 1 (
        echo.
        echo ERRO: Falha ao criar ambiente virtual!
        echo.
        echo Possiveis causas:
        echo   - Python nao tem o modulo venv
        echo   - Permissoes insuficientes na pasta
        echo   - Disco sem espaco
        echo.
        echo Tente executar como administrador ou verifique as permissoes.
        echo.
        pause
        exit /b 1
    )
    echo [OK] Ambiente virtual criado com sucesso!
) else (
    echo [OK] Ambiente virtual ja existe. Pulando criacao...
)
echo.

echo [3/4] Instalando dependencias Python...
echo Ativando ambiente virtual...
if not exist venv\Scripts\activate.bat (
    echo ERRO: Script de ativacao nao encontrado!
    echo O ambiente virtual pode estar corrompido.
    echo Tente deletar a pasta venv e executar setup.bat novamente.
    pause
    exit /b 1
)
call venv\Scripts\activate.bat
echo Atualizando pip...
venv\Scripts\python.exe -m pip install --upgrade pip --quiet
if errorlevel 1 (
    echo AVISO: Falha ao atualizar pip, continuando...
)
echo Instalando dependencias do projeto...
echo Isso pode levar alguns minutos na primeira vez...
echo.

REM Instalar psycopg2-binary primeiro (pode ter problemas no Windows)
echo Instalando psycopg2-binary (driver PostgreSQL)...
venv\Scripts\pip.exe install --no-cache-dir psycopg2-binary
if errorlevel 1 (
    echo.
    echo AVISO: Falha ao instalar psycopg2-binary na primeira tentativa.
    echo Tentando com versao especifica...
    venv\Scripts\pip.exe install --no-cache-dir psycopg2-binary==2.9.8
    if errorlevel 1 (
        echo.
        echo ERRO: Falha ao instalar psycopg2-binary!
        echo.
        echo Execute: instalar_psycopg2_windows.bat para tentar solucoes alternativas
        echo.
        pause
        exit /b 1
    )
)

echo Instalando outras dependencias (usando apenas wheels pre-compilados)...
echo.

REM Instalar pydantic-core primeiro (pode ter problemas de compilacao)
echo Instalando pydantic-core (pode demorar se precisar baixar wheels)...
venv\Scripts\pip.exe install --only-binary :all: --no-cache-dir pydantic-core
if errorlevel 1 (
    echo AVISO: Tentando instalar pydantic-core sem restricao de binary...
    venv\Scripts\pip.exe install --no-cache-dir pydantic-core
)

REM Instalar pydantic
echo Instalando pydantic...
venv\Scripts\pip.exe install --only-binary :all: --no-cache-dir "pydantic>=2.4.0,<3.0.0"
if errorlevel 1 (
    venv\Scripts\pip.exe install --no-cache-dir "pydantic>=2.4.0,<3.0.0"
)

REM Instalar resto das dependencias usando requirements.txt
echo Instalando outras dependencias...
venv\Scripts\pip.exe install --no-cache-dir -r requirements.txt

if errorlevel 1 (
    echo.
    echo AVISO: Algumas dependencias podem ter falhado.
    echo Tentando instalar sem restricao de binary...
    venv\Scripts\pip.exe install --no-cache-dir fastapi==0.104.1
    venv\Scripts\pip.exe install --no-cache-dir "uvicorn[standard]==0.24.0"
    venv\Scripts\pip.exe install --no-cache-dir sqlalchemy==2.0.23
    venv\Scripts\pip.exe install --no-cache-dir "pydantic-settings>=2.0.0,<3.0.0"
    venv\Scripts\pip.exe install --no-cache-dir python-multipart==0.0.6
    venv\Scripts\pip.exe install --no-cache-dir "python-jose[cryptography]==3.3.0"
    venv\Scripts\pip.exe install --no-cache-dir "passlib[bcrypt]==1.7.4"
    venv\Scripts\pip.exe install --no-cache-dir python-dateutil==2.8.2
    venv\Scripts\pip.exe install --no-cache-dir geoip2==4.7.0
    venv\Scripts\pip.exe install --no-cache-dir user-agents==2.2.0
    venv\Scripts\pip.exe install --no-cache-dir httpx==0.25.2
    
    if errorlevel 1 (
        echo.
        echo ERRO: Falha ao instalar dependencias Python!
        echo.
        echo Possiveis causas:
        echo   - Problema de conexao com internet
        echo   - Alguma dependencia incompativel
        echo   - Problema com o pip
        echo.
        echo Solucao: Execute instalar_dependencias_windows.bat
        echo.
        pause
        exit /b 1
    )
)
echo [OK] Dependencias Python instaladas com sucesso!
echo.

echo [4/4] Verificando Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo AVISO: Node.js nao encontrado! O frontend nao funcionara sem Node.js.
    echo Por favor, instale Node.js 18 ou superior de: https://nodejs.org/
    pause
    exit /b 1
)
echo Node.js encontrado:
node --version
npm --version
echo.

echo [5/5] Instalando dependencias do Frontend...
cd frontend
if not exist node_modules (
    echo Instalando dependencias do React...
    call npm install
    if errorlevel 1 (
        echo ERRO: Falha ao instalar dependencias do frontend!
        echo Tente executar manualmente: cd frontend ^&^& npm install
        cd ..
        pause
        exit /b 1
    )
    echo [OK] Dependencias do frontend instaladas com sucesso!
) else (
    echo [OK] Dependencias do frontend ja instaladas. Pulando instalacao...
)
cd ..
echo.

echo [6/6] Configurando banco de dados PostgreSQL...
if not exist backend\.env (
    echo Criando arquivo de configuracao do banco...
    (
        echo # Database Configuration - PostgreSQL
        echo DATABASE_URL=postgresql://tracking:S3v3r1n0_01@72.60.63.29:32541/bd_tracking?sslmode=disable
        echo.
        echo # API Configuration
        echo SECRET_KEY=link-tracking-system-secret-key-2024
        echo.
        echo # CORS Origins - formato JSON array
        echo CORS_ORIGINS=["http://localhost:3000","http://localhost:3001"]
    ) > backend\.env
    echo [OK] Arquivo backend\.env criado!
) else (
    echo [OK] Arquivo backend\.env ja existe.
)
echo.

echo ========================================
echo [SUCESSO] Configuracao concluida!
echo ========================================
echo.
echo Resumo da configuracao:
echo   [OK] Python configurado
echo   [OK] Ambiente virtual criado
echo   [OK] Dependencias Python instaladas
echo   [OK] Node.js configurado
echo   [OK] Dependencias Frontend instaladas
echo   [OK] Banco de dados PostgreSQL configurado
echo.
echo ========================================
echo Para iniciar o sistema:
echo ========================================
echo.
echo Opcao 1 - Iniciar tudo de uma vez:
echo   start_all.bat
echo.
echo Opcao 2 - Iniciar separadamente:
echo   1. Terminal 1: start_backend.bat
echo   2. Terminal 2: start_frontend.bat
echo.
echo Apos iniciar, acesse:
echo   Dashboard: http://localhost:3000
echo   API Docs:  http://localhost:8000/docs
echo.
pause
