@echo off
echo ========================================
echo Configurar Repositorio Git - tracklink
echo ========================================
echo.

REM Navegar para o diretorio do projeto
cd /d "%~dp0"

REM Verificar se git esta instalado
git --version >nul 2>&1
if errorlevel 1 (
    echo ERRO: Git nao encontrado!
    echo Instale Git de: https://git-scm.com/downloads
    pause
    exit /b 1
)

echo [1/4] Inicializando repositorio Git...
if not exist .git (
    git init
    echo [OK] Repositorio inicializado
) else (
    echo [OK] Repositorio Git ja existe
)
echo.

echo [2/4] Configurando remote...
echo.
echo Informe a URL completa do seu repositorio 'tracklink':
echo.
echo Exemplos:
echo   https://github.com/seu-usuario/tracklink.git
echo   https://gitlab.com/seu-usuario/tracklink.git
echo   git@github.com:seu-usuario/tracklink.git
echo.
set /p REPO_URL="URL do repositorio: "

if "%REPO_URL%"=="" (
    echo ERRO: URL nao pode estar vazia!
    pause
    exit /b 1
)

git remote remove origin >nul 2>&1
git remote add origin %REPO_URL%

if errorlevel 1 (
    echo ERRO: Falha ao configurar remote!
    pause
    exit /b 1
)

echo [OK] Remote configurado: %REPO_URL%
echo.

echo [3/4] Verificando branch...
for /f "delims=" %%i in ('git branch --show-current 2^>nul') do set CURRENT_BRANCH=%%i
if "%CURRENT_BRANCH%"=="" (
    echo Criando branch main...
    git checkout -b main
    set CURRENT_BRANCH=main
) else (
    echo Branch atual: %CURRENT_BRANCH%
)
echo.

echo [4/4] Verificando configuracao...
echo.
echo Remote configurado:
git remote -v
echo.
echo Branch atual: %CURRENT_BRANCH%
echo.

echo ========================================
echo Configuracao concluida!
echo ========================================
echo.
echo Agora voce pode:
echo   1. Executar: fazer_commit_push.bat
echo   2. Ou fazer manualmente:
echo      git add .
echo      git commit -m "Mensagem"
echo      git push -u origin %CURRENT_BRANCH%
echo.
pause
