# Documentação Completa - Sistema de Rastreamento de Links DOOH Analytics

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Arquitetura do Sistema](#arquitetura-do-sistema)
3. [Tecnologias Utilizadas](#tecnologias-utilizadas)
4. [Estrutura de Dados](#estrutura-de-dados)
5. [Funcionalidades Detalhadas](#funcionalidades-detalhadas)
6. [API REST - Endpoints](#api-rest---endpoints)
7. [Frontend - Dashboard](#frontend---dashboard)
8. [Sistema de Rastreamento](#sistema-de-rastreamento)
9. [Deploy e Configuração](#deploy-e-configuração)
10. [Fluxo de Funcionamento](#fluxo-de-funcionamento)

---

## Visão Geral

### Descrição

Sistema completo de rastreamento de links desenvolvido especificamente para campanhas **DOOH (Digital Out of Home)**, permitindo criar links rastreáveis, monitorar cliques em tempo real e gerar análises detalhadas de métricas e comportamento dos visitantes.

### Objetivo

Fornecer uma plataforma completa para:
- Criar e gerenciar links rastreáveis com identificadores únicos
- Rastrear cada clique com informações detalhadas do visitante
- Visualizar métricas e analytics através de dashboard interativo
- Filtrar dados por ponto DOOH, campanha e período
- Analisar comportamento por dispositivo, navegador, localização geográfica

### Público-Alvo

- Agências de publicidade
- Empresas de mídia DOOH
- Gestores de campanhas digitais
- Analistas de marketing

---

## Arquitetura do Sistema

### Arquitetura Geral

```
┌─────────────────────────────────────────────────────────────┐
│                    CLIENTE (Navegador)                        │
│  ┌──────────────────┐         ┌──────────────────┐          │
│  │  Dashboard React  │         │  Link Rastreável │          │
│  │  (Porta 3000)     │         │  (Redireciona)   │          │
│  └────────┬──────────┘         └────────┬─────────┘          │
└───────────┼─────────────────────────────┼────────────────────┘
            │                             │
            │ HTTP/HTTPS                  │ HTTP/HTTPS
            │                             │
┌───────────▼─────────────────────────────▼────────────────────┐
│              BACKEND FASTAPI (Porta 8000)                     │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  API REST Endpoints                                   │   │
│  │  - /api/links (CRUD)                                  │   │
│  │  - /api/analytics (Métricas)                          │   │
│  │  - /r/{identifier} (Rastreamento)                     │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Serviços                                             │   │
│  │  - TrackingService (Rastreamento)                     │   │
│  │  - AnalyticsService (Análises)                        │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Servir Frontend Estático                             │   │
│  │  - Arquivos React Build                               │   │
│  │  - React Router (SPA)                                 │   │
│  └──────────────────────────────────────────────────────┘   │
└───────────┬───────────────────────────────────────────────────┘
            │
            │ SQLAlchemy ORM
            │
┌───────────▼───────────────────────────────────────────────────┐
│              PostgreSQL Database                                │
│  ┌──────────────────┐         ┌──────────────────┐           │
│  │   Tabela: links  │         │  Tabela: clicks  │           │
│  │                  │◄────────┤                  │           │
│  │ - id             │         │ - id              │           │
│  │ - identifier     │         │ - link_id (FK)    │           │
│  │ - destination_url│         │ - ip_address     │           │
│  │ - ponto_dooh     │         │ - user_agent      │           │
│  │ - campanha       │         │ - device_type    │           │
│  │ - created_at     │         │ - browser        │           │
│  └──────────────────┘         │ - country        │           │
│                                │ - clicked_at     │           │
│                                └──────────────────┘           │
└───────────────────────────────────────────────────────────────┘
```

### Arquitetura de Deploy (Produção)

**Container Único (Docker):**
- **Stage 1**: Build do frontend React (Node.js 18)
- **Stage 2**: Backend Python + Frontend estático servido pelo FastAPI
- **Porta**: 8000 (única porta para tudo)
- **Vantagens**: Sem problemas de CORS, mais simples de gerenciar, frontend e backend sempre sincronizados

---

## Tecnologias Utilizadas

### Backend

| Tecnologia | Versão | Propósito |
|------------|--------|-----------|
| **Python** | 3.12 | Linguagem principal |
| **FastAPI** | 0.104.1 | Framework web assíncrono para API REST |
| **Uvicorn** | 0.24.0 | Servidor ASGI de alta performance |
| **SQLAlchemy** | ≥2.0.36 | ORM para PostgreSQL |
| **Pydantic** | ≥2.4.0,<3.0.0 | Validação de dados e schemas |
| **Pydantic Settings** | ≥2.0.0 | Gerenciamento de configurações |
| **psycopg2-binary** | ≥2.9.9 | Driver PostgreSQL para Python |
| **user-agents** | 2.2.0 | Parser de User-Agent strings |
| **geoip2** | 4.7.0 | Biblioteca para geolocalização por IP (preparado para uso futuro) |
| **httpx** | 0.25.2 | Cliente HTTP assíncrono |

### Frontend

| Tecnologia | Versão | Propósito |
|------------|--------|-----------|
| **React** | 18.2.0 | Biblioteca JavaScript para UI |
| **React Router DOM** | 6.20.0 | Roteamento SPA (Single Page Application) |
| **Axios** | 1.6.2 | Cliente HTTP para chamadas à API |
| **Recharts** | 2.10.3 | Biblioteca de gráficos e visualizações |
| **date-fns** | 2.30.0 | Manipulação de datas |
| **react-scripts** | 5.0.1 | Build tools e configuração do Create React App |

### Banco de Dados

- **PostgreSQL**: Banco de dados relacional
- **SQLAlchemy ORM**: Mapeamento objeto-relacional

### Infraestrutura

- **Docker**: Containerização da aplicação
- **Easypanel**: Plataforma de deploy e gerenciamento
- **Nginx** (implícito): Servido pelo FastAPI StaticFiles

---

## Estrutura de Dados

### Modelo: Link

Representa um link rastreável cadastrado no sistema.

```python
class Link:
    id: int                    # Chave primária, auto-incremento
    identifier: str            # Identificador único (ex: "campanha-verao-2024")
    destination_url: str      # URL de destino (para onde redireciona)
    ponto_dooh: str           # Nome/localização do ponto DOOH
    campanha: str             # Nome da campanha do cliente
    created_at: datetime      # Data/hora de criação
    updated_at: datetime      # Data/hora da última atualização
    
    # Relacionamento
    clicks: List[Click]        # Lista de cliques registrados
```

**Exemplo:**
```json
{
  "id": 1,
  "identifier": "nike-summer-2024",
  "destination_url": "https://nike.com/promocao-verao",
  "ponto_dooh": "Shopping Center Norte - SP",
  "campanha": "Nike Verão 2024",
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z",
  "total_clicks": 1523
}
```

### Modelo: Click

Representa um clique/visita registrada em um link.

```python
class Click:
    id: int                    # Chave primária, auto-incremento
    link_id: int               # Foreign Key para Link
    ip_address: str           # Endereço IP do visitante
    user_agent: str           # String completa do User-Agent
    referrer: str             # URL de origem (se houver)
    device_type: str           # "mobile", "tablet" ou "desktop"
    browser: str               # Nome e versão do navegador
    operating_system: str      # Sistema operacional
    country: str              # País (via GeoIP - opcional)
    city: str                 # Cidade (via GeoIP - opcional)
    clicked_at: datetime      # Data/hora exata do clique
    
    # Relacionamento
    link: Link                # Link relacionado
```

**Exemplo:**
```json
{
  "id": 12345,
  "link_id": 1,
  "ip_address": "192.168.1.100",
  "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)...",
  "referrer": "https://instagram.com",
  "device_type": "mobile",
  "browser": "Safari 14.0",
  "operating_system": "iOS 14.0",
  "country": "Brasil",
  "city": "São Paulo",
  "clicked_at": "2024-01-20T14:23:15Z"
}
```

### Relacionamentos

- **Link 1:N Click**: Um link pode ter múltiplos cliques
- **Cascade Delete**: Ao deletar um link, todos os seus cliques são automaticamente removidos

---

## Funcionalidades Detalhadas

### 1. Gestão de Links

#### Criar Link
- **Campos obrigatórios:**
  - `identifier`: Identificador único (ex: "campanha-verao-2024")
  - `destination_url`: URL completa de destino
  - `ponto_dooh`: Nome/localização do ponto DOOH
  - `campanha`: Nome da campanha
- **Validações:**
  - Identificador deve ser único (não pode duplicar)
  - URL deve ser válida
- **Resultado:** Link criado e pronto para uso

#### Listar Links
- Lista todos os links cadastrados
- **Filtros opcionais:**
  - Por ponto DOOH
  - Por campanha
- **Paginação:**
  - `skip`: Quantidade de registros a pular
  - `limit`: Quantidade máxima de registros (padrão: 100)
- **Informações retornadas:**
  - Dados do link
  - Total de cliques acumulados

#### Visualizar Link Específico
- Busca por ID do link
- Retorna todos os dados + total de cliques

#### Deletar Link
- Remove o link e todos os seus cliques (cascade delete)
- Operação irreversível

### 2. Sistema de Rastreamento

#### Fluxo de Rastreamento

1. **Usuário acessa:** `https://tracklink.ideiasobria.online/r/{identifier}`
2. **Backend processa:**
   - Busca o link pelo `identifier`
   - Se encontrado:
     - Extrai informações do visitante:
       - IP Address (com suporte a proxies/load balancers)
       - User-Agent completo
       - Referrer (URL de origem)
     - Processa User-Agent:
       - Detecta tipo de dispositivo (mobile/tablet/desktop)
       - Identifica navegador e versão
       - Identifica sistema operacional
     - Opcionalmente obtém geolocalização (preparado para GeoIP)
     - Salva registro de clique no banco
     - Redireciona para `destination_url` (HTTP 302)
   - Se não encontrado:
     - Retorna erro 404

#### Informações Coletadas

**Automaticamente extraídas:**
- IP Address (com detecção de proxies via `X-Forwarded-For` e `X-Real-IP`)
- User-Agent completo
- Referrer (se disponível)
- Timestamp exato do clique

**Processadas do User-Agent:**
- Tipo de dispositivo (mobile/tablet/desktop)
- Navegador e versão
- Sistema operacional e versão

**Preparado para (futuro):**
- Geolocalização por IP (país e cidade) via GeoIP2

### 3. Analytics e Métricas

#### Métricas Gerais

- **Total de Links:** Quantidade de links cadastrados
- **Total de Cliques:** Soma de todos os cliques registrados
- **IPs Únicos:** Quantidade de endereços IP distintos que clicaram

#### Métricas por Categoria

**Clicks por Ponto DOOH:**
- Agrupa cliques por ponto de exibição
- Exemplo: `{"Shopping Center Norte": 450, "Aeroporto GRU": 320}`

**Clicks por Campanha:**
- Agrupa cliques por campanha
- Exemplo: `{"Nike Verão 2024": 1200, "Adidas Inverno": 890}`

**Clicks por Dispositivo:**
- Agrupa por tipo de dispositivo
- Exemplo: `{"mobile": 850, "desktop": 420, "tablet": 130}`

**Clicks por Navegador:**
- Agrupa por navegador utilizado
- Exemplo: `{"Chrome 120.0": 650, "Safari 17.0": 420, "Firefox 121.0": 130}`

**Clicks por País:**
- Agrupa por localização geográfica (quando GeoIP estiver ativo)
- Exemplo: `{"Brasil": 1200, "Argentina": 150, "Chile": 50}`

**Clicks por Dia:**
- Distribuição temporal dos cliques
- Exemplo: `{"2024-01-15": 120, "2024-01-16": 180, "2024-01-17": 95}`

#### Top Links

Lista os 10 links com mais cliques, incluindo:
- ID e identificador do link
- Total de cliques
- IPs únicos
- Distribuição por dispositivo, navegador, país
- Distribuição temporal (por dia)
- Primeiro e último clique registrado

#### Filtros Disponíveis

- **Por Link:** Filtrar métricas de um link específico (por ID)
- **Por Ponto DOOH:** Filtrar por ponto de exibição
- **Por Campanha:** Filtrar por campanha
- **Por Período:**
  - Data inicial (`start_date`: YYYY-MM-DD)
  - Data final (`end_date`: YYYY-MM-DD)

---

## API REST - Endpoints

### Base URL

**Produção:** `https://tracklink.ideiasobria.online`  
**Desenvolvimento:** `http://localhost:8000`

### Autenticação

Atualmente o sistema não possui autenticação. Para produção, recomenda-se implementar:
- JWT (JSON Web Tokens)
- OAuth2
- API Keys

### Endpoints de Links

#### `POST /api/links`

Cria um novo link rastreável.

**Request Body:**
```json
{
  "identifier": "campanha-verao-2024",
  "destination_url": "https://exemplo.com/promocao",
  "ponto_dooh": "Shopping Center Norte - SP",
  "campanha": "Verão 2024"
}
```

**Response (201 Created):**
```json
{
  "id": 1,
  "identifier": "campanha-verao-2024",
  "destination_url": "https://exemplo.com/promocao",
  "ponto_dooh": "Shopping Center Norte - SP",
  "campanha": "Verão 2024",
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z",
  "total_clicks": 0
}
```

**Erros:**
- `400 Bad Request`: Identificador já existe
- `422 Unprocessable Entity`: Dados inválidos

#### `GET /api/links`

Lista todos os links com filtros opcionais.

**Query Parameters:**
- `skip` (int, opcional): Quantidade a pular (padrão: 0)
- `limit` (int, opcional): Quantidade máxima (padrão: 100)
- `ponto_dooh` (string, opcional): Filtrar por ponto
- `campanha` (string, opcional): Filtrar por campanha

**Response (200 OK):**
```json
{
  "links": [
    {
      "id": 1,
      "identifier": "campanha-verao-2024",
      "destination_url": "https://exemplo.com/promocao",
      "ponto_dooh": "Shopping Center Norte - SP",
      "campanha": "Verão 2024",
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T10:30:00Z",
      "total_clicks": 1523
    }
  ],
  "total": 1
}
```

#### `GET /api/links/{link_id}`

Obtém detalhes de um link específico.

**Response (200 OK):**
```json
{
  "id": 1,
  "identifier": "campanha-verao-2024",
  "destination_url": "https://exemplo.com/promocao",
  "ponto_dooh": "Shopping Center Norte - SP",
  "campanha": "Verão 2024",
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z",
  "total_clicks": 1523
}
```

**Erros:**
- `404 Not Found`: Link não encontrado

#### `DELETE /api/links/{link_id}`

Remove um link e todos os seus cliques.

**Response (204 No Content):**

**Erros:**
- `404 Not Found`: Link não encontrado

### Endpoints de Analytics

#### `GET /api/analytics`

Obtém métricas gerais com filtros opcionais.

**Query Parameters:**
- `ponto_dooh` (string, opcional): Filtrar por ponto DOOH
- `campanha` (string, opcional): Filtrar por campanha
- `link_id` (int, opcional): Filtrar por ID do link
- `start_date` (string, opcional): Data inicial (YYYY-MM-DD)
- `end_date` (string, opcional): Data final (YYYY-MM-DD)

**Response (200 OK):**
```json
{
  "total_links": 10,
  "total_clicks": 5230,
  "unique_ips": 3420,
  "clicks_by_ponto": {
    "Shopping Center Norte": 2500,
    "Aeroporto GRU": 1800,
    "Metrô Linha 4": 930
  },
  "clicks_by_campanha": {
    "Nike Verão 2024": 3200,
    "Adidas Inverno": 2030
  },
  "clicks_by_device": {
    "mobile": 3500,
    "desktop": 1500,
    "tablet": 230
  },
  "clicks_by_country": {
    "Brasil": 5000,
    "Argentina": 150,
    "Chile": 80
  },
  "clicks_by_day": {
    "2024-01-15": 450,
    "2024-01-16": 680,
    "2024-01-17": 520
  },
  "top_links": [
    {
      "link_id": 1,
      "identifier": "nike-summer-2024",
      "total_clicks": 1523,
      "unique_ips": 980,
      "clicks_by_device": {"mobile": 1200, "desktop": 323},
      "clicks_by_browser": {"Chrome 120.0": 850, "Safari 17.0": 673},
      "clicks_by_country": {"Brasil": 1500, "Argentina": 23},
      "clicks_by_day": {"2024-01-15": 120, "2024-01-16": 180},
      "first_click": "2024-01-15T08:30:00Z",
      "last_click": "2024-01-20T18:45:00Z"
    }
  ],
  "period_start": "2024-01-15T00:00:00Z",
  "period_end": "2024-01-20T23:59:59Z"
}
```

#### `GET /api/analytics/link/{link_id}`

Obtém métricas detalhadas de um link específico.

**Query Parameters:**
- `start_date` (string, opcional): Data inicial (YYYY-MM-DD)
- `end_date` (string, opcional): Data final (YYYY-MM-DD)

**Response (200 OK):**
```json
{
  "link_id": 1,
  "identifier": "nike-summer-2024",
  "total_clicks": 1523,
  "unique_ips": 980,
  "clicks_by_device": {
    "mobile": 1200,
    "desktop": 323
  },
  "clicks_by_browser": {
    "Chrome 120.0": 850,
    "Safari 17.0": 673
  },
  "clicks_by_country": {
    "Brasil": 1500,
    "Argentina": 23
  },
  "clicks_by_day": {
    "2024-01-15": 120,
    "2024-01-16": 180,
    "2024-01-17": 95
  },
  "first_click": "2024-01-15T08:30:00Z",
  "last_click": "2024-01-20T18:45:00Z"
}
```

**Erros:**
- `404 Not Found`: Link não encontrado

### Endpoint de Rastreamento

#### `GET /r/{identifier}`

Rastreia um clique e redireciona para a URL de destino.

**Parâmetros:**
- `identifier` (path): Identificador único do link

**Comportamento:**
1. Busca o link pelo identificador
2. Se encontrado:
   - Extrai informações do visitante (IP, User-Agent, Referrer)
   - Processa User-Agent (dispositivo, navegador, OS)
   - Salva registro de clique no banco
   - Redireciona para `destination_url` (HTTP 302)
3. Se não encontrado:
   - Retorna erro 404

**Response (302 Found):**
```
Location: https://exemplo.com/promocao
```

**Erros:**
- `404 Not Found`: Link com identificador não encontrado

### Endpoints Auxiliares

#### `GET /`

**Em produção (com frontend):** Retorna `index.html` do React (dashboard)  
**Sem frontend:** Retorna JSON com informações da API

**Response (sem frontend):**
```json
{
  "message": "Link Tracking System API",
  "version": "1.0.0",
  "docs": "/docs"
}
```

#### `GET /health`

Health check do sistema.

**Response (200 OK):**
```json
{
  "status": "healthy"
}
```

#### `GET /docs`

Documentação interativa da API (Swagger UI do FastAPI).

#### `GET /openapi.json`

Esquema OpenAPI da API em formato JSON.

---

## Frontend - Dashboard

### Estrutura

**Framework:** React 18.2.0 com React Router DOM 6.20.0  
**Build Tool:** Create React App (react-scripts 5.0.1)  
**Estilização:** CSS puro (sem frameworks CSS)  
**Gráficos:** Recharts 2.10.3  
**HTTP Client:** Axios 1.6.2

### Componentes Principais

#### 1. App.js
- Componente raiz da aplicação
- Configura roteamento (React Router)
- Estrutura básica: Header + Main content

**Rotas:**
- `/` → Dashboard (componente principal)
- `/create` → Criar novo link

#### 2. Dashboard.js
- Componente principal de visualização
- **Funcionalidades:**
  - Carrega lista de links
  - Carrega métricas gerais
  - Exibe cards com estatísticas (Total Links, Total Cliques, IPs Únicos)
  - Renderiza gráficos de analytics
  - Exibe tabela de links cadastrados
  - Permite deletar links
  - Aplica filtros (ponto, campanha, período)

**Estados:**
- `links`: Array de links cadastrados
- `analytics`: Objeto com métricas e estatísticas
- `loading`: Estado de carregamento
- `filters`: Objeto com filtros ativos

**Métodos:**
- `loadData()`: Carrega links e analytics da API
- `handleDeleteLink(linkId)`: Remove um link
- `handleFilterChange(newFilters)`: Atualiza filtros e recarrega dados

#### 3. CreateLink.js
- Formulário para criar novo link
- **Campos:**
  - Identificador (único)
  - URL de destino
  - Ponto DOOH
  - Campanha
- **Validações:** Frontend básicas + validação do backend
- **Ação:** POST para `/api/links`

#### 4. LinksTable.js
- Tabela responsiva com links cadastrados
- **Colunas:**
  - Identificador
  - URL de destino (truncada)
  - Ponto DOOH
  - Campanha
  - Total de cliques
  - Data de criação
  - Ações (deletar)
- **Funcionalidades:**
  - Ordenação visual
  - Botão de deletar com confirmação

#### 5. AnalyticsCharts.js
- Visualizações gráficas das métricas
- **Gráficos:**
  - Cliques por Ponto DOOH (Bar Chart)
  - Cliques por Campanha (Bar Chart)
  - Cliques por Dispositivo (Pie Chart)
  - Cliques por País (Bar Chart)
  - Cliques por Dia (Line Chart)
- **Biblioteca:** Recharts

#### 6. Filters.js
- Componente de filtros
- **Filtros disponíveis:**
  - Ponto DOOH (dropdown)
  - Campanha (dropdown)
  - Data inicial (date picker)
  - Data final (date picker)
- **Comportamento:** Atualiza filtros e dispara recarga automática dos dados

### Serviços

#### api.js
- Cliente HTTP centralizado (Axios)
- **Configuração:**
  - Base URL: `process.env.REACT_APP_API_URL` ou relativa em produção
  - Headers: `Content-Type: application/json`
- **APIs expostas:**
  - `linksAPI`: CRUD de links
  - `analyticsAPI`: Métricas e analytics

### Fluxo de Dados

```
Dashboard Component
    │
    ├─→ linksAPI.list(filters) ──→ GET /api/links
    │                                    │
    │                                    └─→ PostgreSQL
    │
    └─→ analyticsAPI.get(filters) ──→ GET /api/analytics
                                             │
                                             └─→ PostgreSQL
```

---

## Sistema de Rastreamento

### Processo Detalhado

#### 1. Acesso ao Link Rastreável

**URL:** `https://tracklink.ideiasobria.online/r/{identifier}`

Exemplo: `https://tracklink.ideiasobria.online/r/nike-summer-2024`

#### 2. Processamento no Backend

**Endpoint:** `GET /r/{identifier}`

**Fluxo:**

1. **Busca do Link:**
   ```python
   link = db.query(Link).filter(Link.identifier == identifier).first()
   ```

2. **Extração de Informações:**
   - **IP Address:**
     - Verifica `X-Forwarded-For` (proxies/load balancers)
     - Verifica `X-Real-IP` (nginx reverse proxy)
     - Fallback para `request.client.host`
   - **User-Agent:** Extraído de `request.headers.get("User-Agent")`
   - **Referrer:** Extraído de `request.headers.get("Referer")`

3. **Processamento do User-Agent:**
   - Biblioteca: `user-agents`
   - Detecta:
     - Tipo de dispositivo (mobile/tablet/desktop)
     - Navegador e versão
     - Sistema operacional e versão

4. **Geolocalização (Preparado):**
   - Biblioteca: `geoip2`
   - Atualmente retorna `null` (não implementado)
   - Preparado para integração com MaxMind GeoIP2 ou ipapi.co

5. **Persistência:**
   ```python
   click = Click(
       link_id=link.id,
       ip_address=ip_address,
       user_agent=user_agent,
       referrer=referrer,
       device_type="mobile",
       browser="Safari 14.0",
       operating_system="iOS 14.0",
       country=None,  # Futuro: via GeoIP
       city=None      # Futuro: via GeoIP
   )
   db.add(click)
   db.commit()
   ```

6. **Redirecionamento:**
   ```python
   return RedirectResponse(
       url=link.destination_url,
       status_code=302  # HTTP Found (Temporary Redirect)
   )
   ```

### Exemplo Completo

**Request:**
```
GET /r/nike-summer-2024 HTTP/1.1
Host: tracklink.ideiasobria.online
User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15
Referer: https://instagram.com/p/ABC123
X-Forwarded-For: 192.168.1.100
```

**Processamento:**
1. Busca link com `identifier="nike-summer-2024"`
2. Extrai IP: `192.168.1.100` (de X-Forwarded-For)
3. Processa User-Agent:
   - Device: `mobile`
   - Browser: `Safari 14.0`
   - OS: `iOS 14.0`
4. Salva click no banco
5. Redireciona para `https://nike.com/promocao-verao`

**Response:**
```
HTTP/1.1 302 Found
Location: https://nike.com/promocao-verao
```

**Registro no Banco:**
```json
{
  "id": 12345,
  "link_id": 1,
  "ip_address": "192.168.1.100",
  "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0...)",
  "referrer": "https://instagram.com/p/ABC123",
  "device_type": "mobile",
  "browser": "Safari 14.0",
  "operating_system": "iOS 14.0",
  "country": null,
  "city": null,
  "clicked_at": "2024-01-20T14:23:15Z"
}
```

---

## Deploy e Configuração

### Arquitetura de Deploy

**Container Único (Docker Multi-Stage):**

```dockerfile
# Stage 1: Build Frontend
FROM node:18-alpine AS frontend-build
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ .
RUN npm run build

# Stage 2: Backend + Frontend Estático
FROM python:3.12-slim
WORKDIR /app
# Instalar dependências Python
COPY requirements.txt .
RUN pip install -r requirements.txt
# Copiar backend
COPY backend ./backend
# Copiar build do frontend
COPY --from=frontend-build /app/frontend/build ./static
WORKDIR /app/backend
EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Configuração no Easypanel

**Serviço:**
- Tipo: Dockerfile
- Dockerfile path: `Dockerfile`
- Build context: `.` (raiz do repositório)
- Application Port: `8000`

**Domínios:**
- `https://tracklink.ideiasobria.online/` → `http://outdoora_tracklink:8000/`

### Variáveis de Ambiente

**Backend (.env):**
```env
DATABASE_URL=postgresql://user:password@host:port/database
SECRET_KEY=your-secret-key
CORS_ORIGINS=https://tracklink.ideiasobria.online,https://dashboard.tracklink.ideiasobria.online
```

**Frontend (Build Time):**
```env
REACT_APP_API_URL=https://tracklink.ideiasobria.online
```

### Banco de Dados

**PostgreSQL:**
- Host: Configurado via `DATABASE_URL`
- Tabelas criadas automaticamente via SQLAlchemy `Base.metadata.create_all()`
- Migrations: Não implementadas (criação automática)

### CORS (Cross-Origin Resource Sharing)

**Configuração:**
- Origens permitidas configuráveis via `CORS_ORIGINS` em `settings`
- Métodos: GET, POST, PUT, DELETE, OPTIONS, PATCH
- Headers: Todos permitidos
- Credentials: Habilitado

**Origens padrão:**
- `http://localhost:3000` (desenvolvimento)
- `http://localhost:3001` (desenvolvimento alternativo)
- `https://tracklink.ideiasobria.online` (produção)
- `https://docs.tracklink.ideiasobria.online` (produção docs)
- `https://dashboard.tracklink.ideiasobria.online` (produção dashboard)

---

## Fluxo de Funcionamento

### Fluxo Completo: Criar Link → Rastrear → Visualizar

#### 1. Criar Link (Dashboard)

```
Usuário acessa Dashboard
    │
    ├─→ Clica em "Criar Novo Link"
    │
    ├─→ Preenche formulário:
    │   - Identifier: "nike-summer-2024"
    │   - URL: "https://nike.com/promocao"
    │   - Ponto: "Shopping Center Norte"
    │   - Campanha: "Nike Verão 2024"
    │
    └─→ POST /api/links
            │
            └─→ Backend valida e salva no PostgreSQL
                    │
                    └─→ Retorna link criado
                            │
                            └─→ Dashboard atualiza lista
```

#### 2. Compartilhar Link Rastreável

```
Link gerado: https://tracklink.ideiasobria.online/r/nike-summer-2024
    │
    └─→ Compartilhado em:
        - QR Code em painel DOOH
        - Redes sociais
        - Email marketing
        - SMS
```

#### 3. Usuário Clica no Link

```
Visitante clica no link rastreável
    │
    ├─→ GET /r/nike-summer-2024
    │
    ├─→ Backend processa:
    │   ├─→ Busca link no banco
    │   ├─→ Extrai IP, User-Agent, Referrer
    │   ├─→ Processa User-Agent (dispositivo, navegador, OS)
    │   ├─→ Salva click no banco
    │   └─→ Redireciona para destination_url (302)
    │
    └─→ Visitante é redirecionado para https://nike.com/promocao
```

#### 4. Visualizar Métricas (Dashboard)

```
Gestor acessa Dashboard
    │
    ├─→ GET /api/links?ponto_dooh=Shopping Center Norte
    │   └─→ Retorna lista de links filtrados
    │
    ├─→ GET /api/analytics?ponto_dooh=Shopping Center Norte&start_date=2024-01-15
    │   └─→ Retorna métricas agregadas
    │
    └─→ Dashboard renderiza:
        ├─→ Cards com estatísticas (Total Links, Cliques, IPs Únicos)
        ├─→ Gráficos (por ponto, campanha, dispositivo, país, dia)
        └─→ Tabela de links com total de cliques
```

### Fluxo de Dados no Backend

```
Request → FastAPI App
    │
    ├─→ CORS Middleware (valida origem)
    │
    ├─→ Router (roteia para endpoint correto)
    │
    ├─→ Dependency Injection (get_db → Session PostgreSQL)
    │
    ├─→ Service Layer (lógica de negócio)
    │   ├─→ TrackingService (rastreamento)
    │   └─→ AnalyticsService (métricas)
    │
    ├─→ ORM (SQLAlchemy)
    │
    └─→ PostgreSQL Database
```

### Fluxo de Dados no Frontend

```
User Interaction
    │
    ├─→ React Component (Dashboard, CreateLink, etc.)
    │
    ├─→ API Service (api.js)
    │   └─→ Axios HTTP Request
    │
    ├─→ Backend API (FastAPI)
    │
    └─→ Response → Component State → UI Update
```

---

## Considerações Finais

### Segurança

**Implementado:**
- Validação de dados via Pydantic
- CORS configurável
- Sanitização de inputs

**Recomendações para Produção:**
- Implementar autenticação (JWT/OAuth2)
- Rate limiting
- HTTPS obrigatório
- Validação de URLs de destino
- Sanitização de User-Agent
- Logs de segurança

### Performance

**Otimizações:**
- Queries otimizadas com índices no banco
- Agregações calculadas em memória (para datasets pequenos/médios)
- Frontend servido como arquivos estáticos

**Recomendações para Escala:**
- Cache de métricas (Redis)
- Paginação eficiente
- Índices adicionais no banco
- CDN para arquivos estáticos
- Load balancing

### Melhorias Futuras

- **Geolocalização:** Integração com MaxMind GeoIP2 ou ipapi.co
- **Autenticação:** Sistema de login e permissões
- **Exportação:** Download de relatórios em PDF/Excel
- **Notificações:** Alertas por email/SMS
- **API Rate Limiting:** Proteção contra abuso
- **Migrations:** Alembic para versionamento do banco
- **Testes:** Unit tests e integration tests
- **Monitoramento:** Logs estruturados e métricas de performance

---

**Versão do Documento:** 1.0  
**Última Atualização:** 2024-01-20  
**Autor:** Sistema de Rastreamento de Links DOOH Analytics
