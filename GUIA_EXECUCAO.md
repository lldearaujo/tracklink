# 🚀 Guia de Execução Local

Este guia explica como configurar e executar o sistema de rastreamento de links localmente.

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- **Python 3.11 ou superior** - [Download](https://www.python.org/downloads/)
- **Node.js 18 ou superior** - [Download](https://nodejs.org/)
- **npm** (vem com Node.js)

## 🔧 Configuração Inicial (Primeira Vez)

### Opção 1: Script Automático (Recomendado - Windows)

Execute o script de configuração:

```bash
setup.bat
```

Este script irá:
- ✅ Verificar se Python e Node.js estão instalados
- ✅ Criar ambiente virtual Python
- ✅ Instalar todas as dependências do backend
- ✅ Instalar todas as dependências do frontend

### Opção 2: Manual

#### Backend

```bash
# Criar ambiente virtual
python -m venv venv

# Ativar ambiente virtual (Windows)
venv\Scripts\activate

# Ativar ambiente virtual (Linux/Mac)
source venv/bin/activate

# Instalar dependências
pip install -r requirements.txt
```

#### Frontend

```bash
cd frontend
npm install
cd ..
```

## ▶️ Executando o Sistema

### Opção 1: Iniciar Tudo de Uma Vez (Windows)

Execute:

```bash
start_all.bat
```

Isso abrirá duas janelas:
- **Backend** na porta 8000
- **Frontend** na porta 3000

### Opção 2: Iniciar Separadamente

#### Terminal 1 - Backend

```bash
start_backend.bat
```

Ou manualmente:
```bash
venv\Scripts\activate
cd backend
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

#### Terminal 2 - Frontend

```bash
start_frontend.bat
```

Ou manualmente:
```bash
cd frontend
npm start
```

## 🌐 Acessando o Sistema

Após iniciar os servidores:

- **Dashboard**: http://localhost:3000
- **API Backend**: http://localhost:8000
- **Documentação da API**: http://localhost:8000/docs
- **Health Check**: http://localhost:8000/health

## 🛑 Parando o Sistema

### Windows

Execute:
```bash
stop_all.bat
```

Ou feche manualmente as janelas dos servidores (Ctrl+C em cada terminal).

### Linux/Mac

```bash
# Parar frontend
pkill -f "react-scripts"

# Parar backend
pkill -f "uvicorn"
```

## 🔍 Verificando se Está Funcionando

1. **Backend**: Acesse http://localhost:8000/docs - você deve ver a documentação interativa da API
2. **Frontend**: Acesse http://localhost:3000 - você deve ver o dashboard

## 🐛 Solução de Problemas

### Erro: "Python não encontrado"
- Certifique-se de que Python está instalado e no PATH
- Verifique com: `python --version`

### Erro: "Node.js não encontrado"
- Certifique-se de que Node.js está instalado
- Verifique com: `node --version`

### Erro: "Porta já em uso"
- Backend (8000): Verifique se há outro processo usando a porta
- Frontend (3000): O React geralmente pergunta se quer usar outra porta

### Erro: "Módulo não encontrado"
- Execute `setup.bat` novamente para reinstalar dependências
- Ou manualmente: `pip install -r requirements.txt` e `cd frontend && npm install`

### Banco de dados não conecta
- Execute `testar_conexao_db.bat` para verificar a conexão
- Verifique as credenciais em `backend/.env`
- Certifique-se de que o servidor PostgreSQL está acessível
- Veja [CONFIGURACAO_BANCO.md](CONFIGURACAO_BANCO.md) para mais detalhes

### Tabelas não criadas
- As tabelas PostgreSQL serão criadas automaticamente na primeira execução
- Certifique-se de que a conexão com o banco está funcionando

## 📝 Primeiros Passos

1. Acesse o dashboard: http://localhost:3000
2. Clique em "Criar Novo Link"
3. Preencha:
   - **Identificador**: `teste-001`
   - **URL de Destino**: `https://google.com`
   - **Ponto DOOH**: `Shopping Teste`
   - **Campanha**: `Campanha Teste`
4. Clique em "Criar Link"
5. Copie o link rastreável gerado
6. Abra o link em uma nova aba
7. Volte ao dashboard e veja as métricas atualizadas!

## 🔄 Atualizando o Sistema

Se você fez alterações no código:

1. **Backend**: O servidor recarrega automaticamente (graças ao `--reload`)
2. **Frontend**: O React recarrega automaticamente quando você salva arquivos

## 📦 Estrutura de Arquivos

```
.
├── backend/              # API FastAPI
│   ├── app/
│   └── main.py
├── frontend/             # Aplicação React
│   └── src/
├── venv/                 # Ambiente virtual Python (criado após setup)
├── setup.bat             # Script de configuração
├── start_all.bat         # Iniciar tudo
├── start_backend.bat     # Iniciar apenas backend
├── start_frontend.bat    # Iniciar apenas frontend
└── stop_all.bat          # Parar tudo
```

## 💡 Dicas

- Mantenha os dois servidores rodando simultaneamente
- Use `start_all.bat` para facilitar o desenvolvimento
- A documentação da API em `/docs` é interativa - você pode testar endpoints diretamente
- O banco de dados SQLite é criado automaticamente na primeira execução

## 🆘 Precisa de Ajuda?

Se encontrar problemas:
1. Verifique se Python e Node.js estão instalados corretamente
2. Execute `setup.bat` novamente
3. Verifique os logs nos terminais dos servidores
4. Certifique-se de que as portas 3000 e 8000 estão livres
