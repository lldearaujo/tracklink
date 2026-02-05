# 📦 Guia: Commit e Push para Repositório tracklink

## 🚀 Início Rápido

### 1. Configurar o Repositório (Primeira Vez)

Execute:

```bash
configurar_git.bat
```

Você precisará informar a URL do seu repositório, por exemplo:
- `https://github.com/seu-usuario/tracklink.git`
- `https://gitlab.com/seu-usuario/tracklink.git`

### 2. Fazer Commit e Push

Execute:

```bash
fazer_commit_push.bat
```

Este script vai:
- ✅ Adicionar todos os arquivos
- ✅ Fazer commit com mensagem descritiva
- ✅ Fazer push para o repositório remoto

## 📝 Passo a Passo Manual

Se preferir fazer manualmente:

### 1. Inicializar Repositório (se necessário)

```bash
git init
```

### 2. Configurar Remote

```bash
git remote add origin https://github.com/seu-usuario/tracklink.git
```

Ou se já existe:

```bash
git remote set-url origin https://github.com/seu-usuario/tracklink.git
```

### 3. Adicionar Arquivos

```bash
git add .
```

### 4. Fazer Commit

```bash
git commit -m "Sistema de rastreamento de links - DOOH Analytics

- Backend FastAPI com PostgreSQL
- Frontend React com dashboard
- Sistema de rastreamento de links
- Analytics e métricas
- Configuração completa para Windows"
```

### 5. Fazer Push

```bash
git push -u origin main
```

Ou se a branch for `master`:

```bash
git push -u origin master
```

## 🔒 Autenticação

Se for a primeira vez fazendo push, pode precisar autenticar:

### GitHub
- Use Personal Access Token (PAT)
- Ou configure SSH keys

### GitLab
- Use Personal Access Token
- Ou configure SSH keys

## 📋 Arquivos que Serão Commitados

O `.gitignore` está configurado para **NÃO** commitar:
- ❌ `venv/` (ambiente virtual)
- ❌ `node_modules/` (dependências do frontend)
- ❌ `backend/.env` (credenciais do banco)
- ❌ `*.db`, `*.sqlite` (bancos de dados locais)
- ❌ Arquivos de log

## ⚠️ Importante

**NUNCA** commite:
- Arquivos `.env` com credenciais
- Senhas ou tokens
- Dados sensíveis

O `.gitignore` já está configurado para proteger isso!

## 🆘 Problemas Comuns

### Erro: "remote origin already exists"
```bash
git remote remove origin
git remote add origin URL_DO_REPOSITORIO
```

### Erro: "authentication failed"
- Configure autenticação (token ou SSH)
- Verifique suas credenciais

### Erro: "branch does not exist"
```bash
git checkout -b main
git push -u origin main
```

## 📖 Comandos Úteis

```bash
# Ver status
git status

# Ver remotes configurados
git remote -v

# Ver branch atual
git branch

# Ver histórico de commits
git log --oneline

# Ver diferenças
git diff
```
