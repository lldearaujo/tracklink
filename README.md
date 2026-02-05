# Sistema de Rastreamento de Links - DOOH Analytics

Sistema completo para rastreamento de links com dashboard de métricas, desenvolvido para campanhas DOOH (Digital Out of Home).

## 🚀 Funcionalidades

- **Gestão de Links**: Criação de links rastreáveis com identificador único, ponto DOOH e campanha
- **Rastreamento Avançado**: Coleta automática de dados do visitante (IP, localização, dispositivo, navegador)
- **Dashboard Analytics**: Visualização de métricas com filtros por ponto, campanha e período
- **API RESTful**: Backend completo em FastAPI seguindo boas práticas

## 📋 Pré-requisitos

- Python 3.11+
- Node.js 18+ (para o frontend)
- npm ou yarn
- **PostgreSQL** - Banco de dados configurado (credenciais já configuradas)

## 🛠️ Instalação e Execução

### Configuração Inicial (Primeira Vez)

#### Windows
```bash
# Executar script de configuração automática
setup.bat

# Ou iniciar tudo de uma vez
start_all.bat
```

#### Linux/Mac
```bash
# Dar permissão de execução aos scripts
chmod +x setup.sh start_all.sh start_backend.sh start_frontend.sh

# Executar script de configuração
./setup.sh

# Ou iniciar tudo de uma vez
./start_all.sh
```

### Execução Manual

#### Backend

**Windows:**
```bash
start_backend.bat
```

**Linux/Mac:**
```bash
./start_backend.sh
```

**Ou manualmente:**
```bash
# Ativar ambiente virtual
# Windows: venv\Scripts\activate
# Linux/Mac: source venv/bin/activate

cd backend
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

#### Frontend

**Windows:**
```bash
start_frontend.bat
```

**Linux/Mac:**
```bash
./start_frontend.sh
```

**Ou manualmente:**
```bash
cd frontend
npm start
```

### Acessar o Sistema

Após iniciar os servidores:

- **Dashboard**: http://localhost:3000
- **API Backend**: http://localhost:8000
- **Documentação da API**: http://localhost:8000/docs
- **Health Check**: http://localhost:8000/health

### Verificar Ambiente

**Windows:**
```bash
verificar_ambiente.bat
```

Este script verifica se todas as dependências estão instaladas corretamente.

📖 **Para mais detalhes, consulte o [GUIA_EXECUCAO.md](GUIA_EXECUCAO.md)**

## 📁 Estrutura do Projeto

```
.
├── backend/           # API FastAPI
│   ├── app/
│   │   ├── models/    # Modelos de banco de dados
│   │   ├── schemas/   # Schemas Pydantic
│   │   ├── api/       # Endpoints da API
│   │   ├── core/      # Configurações e utilitários
│   │   └── services/  # Lógica de negócio
│   └── main.py
├── frontend/          # Aplicação React
└── requirements.txt
```

## 🔗 Uso

1. Acesse o dashboard em `http://localhost:3000`
2. Crie um novo link informando:
   - Ponto (DOOH)
   - Campanha do cliente
   - Identificador único
   - URL de destino
3. Compartilhe o link gerado
4. Visualize as métricas no dashboard

## 📊 API Endpoints

- `GET /api/links` - Listar todos os links
- `POST /api/links` - Criar novo link
- `GET /api/links/{link_id}` - Detalhes do link
- `GET /r/{identifier}` - Rastrear e redirecionar
- `GET /api/analytics` - Métricas do dashboard
- `GET /api/analytics/{link_id}` - Métricas de um link específico
