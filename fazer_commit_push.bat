@echo off
echo ========================================
echo Commit e Push para Repositorio tracklink
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

echo [1/5] Verificando repositorio Git...
if not exist .git (
    echo Inicializando repositorio Git...
    git init
    if errorlevel 1 (
        echo ERRO: Falha ao inicializar repositorio!
        pause
        exit /b 1
    )
    echo [OK] Repositorio inicializado
) else (
    echo [OK] Repositorio Git ja existe
)
echo.

echo [2/5] Verificando remote...
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo.
    echo Remote nao configurado!
    echo.
    echo Execute primeiro: configurar_git.bat
    echo Ou configure manualmente:
    echo   git remote add origin URL_DO_REPOSITORIO
    echo.
    pause
    exit /b 1
) else (
    echo [OK] Remote configurado:
    git remote -v
)
echo.

echo [3/5] Verificando branch...
for /f "delims=" %%i in ('git branch --show-current 2^>nul') do set CURRENT_BRANCH=%%i
if "%CURRENT_BRANCH%"=="" (
    echo Criando branch main...
    git checkout -b main
    set CURRENT_BRANCH=main
) else (
    echo Branch atual: %CURRENT_BRANCH%
)
echo.

echo [4/5] Adicionando arquivos ao commit...
git add .
if errorlevel 1 (
    echo ERRO: Falha ao adicionar arquivos!
    pause
    exit /b 1
)

echo.
echo Arquivos que serao commitados:
git status --short | head -20
echo.

choice /C SN /M "Deseja continuar com o commit"
if errorlevel 2 (
    echo Commit cancelado.
    pause
    exit /b 0
)

echo.
echo [5/5] Fazendo commit...
git commit -m "Sistema de rastreamento de links - DOOH Analytics

- Backend FastAPI com PostgreSQL
- Frontend React com dashboard
- Sistema de rastreamento de links
- Analytics e metricas
- Configuracao completa para Windows"

if errorlevel 1 (
    echo.
    echo AVISO: Nenhuma mudanca para commitar ou commit falhou
    echo Verifique: git status
) else (
    echo [OK] Commit realizado com sucesso!
    echo.
    echo Fazendo push para o repositorio...
    git push -u origin %CURRENT_BRANCH%
    if errorlevel 1 (
        echo.
        echo Tentando branch main...
        git push -u origin main
        if errorlevel 1 (
            echo.
            echo Tentando branch master...
            git push -u origin master
            if errorlevel 1 (
                echo.
                echo ERRO: Falha ao fazer push!
                echo.
                echo Possiveis causas:
                echo   1. Repositorio remoto nao existe
                echo   2. Nao tem permissao
                echo   3. Precisa configurar autenticacao
                echo   4. Branch nao existe no remoto
                echo.
                echo Configure o remote primeiro:
                echo   configurar_git.bat
                echo.
            ) else (
                echo [OK] Push realizado com sucesso para branch master!
            )
        ) else (
            echo [OK] Push realizado com sucesso para branch main!
        )
    ) else (
        echo [OK] Push realizado com sucesso!
    )
)

echo.
echo ========================================
echo Concluido!
echo ========================================
echo.
pause
