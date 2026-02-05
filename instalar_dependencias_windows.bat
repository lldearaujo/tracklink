@echo off
echo ========================================
echo Instalacao de Dependencias para Windows
echo (Usando apenas wheels pre-compilados)
echo ========================================
echo.

if not exist venv (
    echo ERRO: Ambiente virtual nao encontrado!
    echo Execute setup.bat primeiro para criar o ambiente virtual.
    pause
    exit /b 1
)

echo Ativando ambiente virtual...
call venv\Scripts\activate.bat

echo.
echo Atualizando pip...
venv\Scripts\python.exe -m pip install --upgrade pip --quiet

echo.
echo ========================================
echo Estrategia: Instalar apenas wheels pre-compilados
echo (Evita necessidade de Rust/C++ Build Tools)
echo ========================================
echo.

REM Instalar psycopg2-binary primeiro
echo [1/6] Instalando psycopg2-binary...
venv\Scripts\pip.exe install --no-cache-dir --only-binary :all: psycopg2-binary
if errorlevel 1 (
    echo Tentando sem restricao de binary...
    venv\Scripts\pip.exe install --no-cache-dir psycopg2-binary
)
echo.

REM Instalar pydantic-core (pode precisar de compilacao, mas vamos tentar wheels primeiro)
echo [2/6] Instalando pydantic-core...
venv\Scripts\pip.exe install --no-cache-dir --only-binary :all: pydantic-core
if errorlevel 1 (
    echo Tentando versao especifica com wheel...
    venv\Scripts\pip.exe install --no-cache-dir pydantic-core==2.23.0
    if errorlevel 1 (
        echo AVISO: pydantic-core pode precisar de compilacao
        echo Tentando instalar sem restricao...
        venv\Scripts\pip.exe install --no-cache-dir pydantic-core
    )
)
echo.

REM Instalar pydantic
echo [3/6] Instalando pydantic...
venv\Scripts\pip.exe install --no-cache-dir --only-binary :all: "pydantic>=2.4.0,<3.0.0"
if errorlevel 1 (
    venv\Scripts\pip.exe install --no-cache-dir "pydantic>=2.4.0,<3.0.0"
)
echo.

REM Instalar pydantic-settings
echo [4/6] Instalando pydantic-settings...
venv\Scripts\pip.exe install --no-cache-dir --only-binary :all: "pydantic-settings>=2.0.0,<3.0.0"
if errorlevel 1 (
    venv\Scripts\pip.exe install --no-cache-dir "pydantic-settings>=2.0.0,<3.0.0"
)
echo.

REM Instalar outras dependencias principais
echo [5/6] Instalando FastAPI e dependencias principais...
venv\Scripts\pip.exe install --no-cache-dir --only-binary :all: fastapi==0.104.1 "uvicorn[standard]==0.24.0" sqlalchemy==2.0.23
if errorlevel 1 (
    venv\Scripts\pip.exe install --no-cache-dir fastapi==0.104.1 "uvicorn[standard]==0.24.0" sqlalchemy==2.0.23
)
echo.

REM Instalar dependencias restantes
echo [6/6] Instalando dependencias restantes...
venv\Scripts\pip.exe install --no-cache-dir --only-binary :all: python-multipart==0.0.6 "python-jose[cryptography]==3.3.0" "passlib[bcrypt]==1.7.4" python-dateutil==2.8.2 geoip2==4.7.0 user-agents==2.2.0 httpx==0.25.2

if errorlevel 1 (
    echo Tentando sem restricao de binary...
    venv\Scripts\pip.exe install --no-cache-dir python-multipart==0.0.6 "python-jose[cryptography]==3.3.0" "passlib[bcrypt]==1.7.4" python-dateutil==2.8.2 geoip2==4.7.0 user-agents==2.2.0 httpx==0.25.2
)
echo.

echo ========================================
echo Verificando instalacao...
echo ========================================
echo.

venv\Scripts\python.exe -c "import fastapi; print('[OK] FastAPI')" 2>nul
venv\Scripts\python.exe -c "import pydantic; print('[OK] Pydantic')" 2>nul
venv\Scripts\python.exe -c "import psycopg2; print('[OK] psycopg2-binary')" 2>nul
venv\Scripts\python.exe -c "import sqlalchemy; print('[OK] SQLAlchemy')" 2>nul

echo.
echo ========================================
echo [SUCESSO] Dependencias instaladas!
echo ========================================
echo.
echo Se algum modulo falhou, tente instalar manualmente:
echo   venv\Scripts\activate.bat
echo   pip install --no-cache-dir NOME_DO_MODULO
echo.
pause
