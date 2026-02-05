# 🗄️ Configuração do Banco de Dados PostgreSQL

O sistema está configurado para usar **PostgreSQL** como banco de dados.

## 📋 Credenciais Configuradas

### Conexão Externa (Desenvolvimento Local)
- **Host**: `72.60.63.29`
- **Porta**: `32541`
- **Usuário**: `tracking`
- **Senha**: `S3v3r1n0_01`
- **Banco**: `bd_tracking`

### Conexão Interna (Rede Interna)
- **Host**: `outdoora_bd_tracking`
- **Porta**: `5432`
- **Usuário**: `tracking`
- **Senha**: `S3v3r1n0_01`
- **Banco**: `bd_tracking`

## 🔧 Configuração

As credenciais estão configuradas em:
- `backend/.env` - Arquivo de configuração (já criado)
- `backend/app/core/config.py` - Configuração padrão

### Alterar Configuração

Para usar a conexão interna, edite `backend/.env`:

```env
# Descomente esta linha e comente a externa
DATABASE_URL=postgresql://tracking:S3v3r1n0_01@outdoora_bd_tracking:5432/bd_tracking?sslmode=disable
```

## ✅ Testar Conexão

Execute o script de teste:

```bash
testar_conexao_db.bat
```

Ou manualmente:

```bash
cd backend
python -c "from app.core.database import engine; engine.connect(); print('Conexão OK!')"
```

## 📊 Estrutura do Banco

O sistema criará automaticamente as seguintes tabelas na primeira execução:

### Tabela: `links`
- `id` - ID único do link
- `identifier` - Identificador único (único)
- `destination_url` - URL de destino
- `ponto_dooh` - Ponto DOOH
- `campanha` - Campanha do cliente
- `created_at` - Data de criação
- `updated_at` - Data de atualização

### Tabela: `clicks`
- `id` - ID único do clique
- `link_id` - Referência ao link (FK)
- `ip_address` - IP do visitante
- `user_agent` - User agent do navegador
- `referrer` - Referrer
- `device_type` - Tipo de dispositivo
- `browser` - Navegador
- `operating_system` - Sistema operacional
- `country` - País
- `city` - Cidade
- `clicked_at` - Data/hora do clique

## 🔒 Segurança

⚠️ **Importante**: 
- O arquivo `.env` está no `.gitignore` e não será commitado
- Nunca compartilhe as credenciais publicamente
- Use variáveis de ambiente em produção

## 🐛 Solução de Problemas

### Erro: "could not connect to server"
- Verifique se o servidor PostgreSQL está acessível
- Verifique firewall/rede
- Teste a conexão com um cliente PostgreSQL (pgAdmin, DBeaver)

### Erro: "authentication failed"
- Verifique usuário e senha no arquivo `.env`
- Certifique-se de que o usuário tem permissões no banco

### Erro: "database does not exist"
- O banco `bd_tracking` deve existir no servidor
- Crie o banco se necessário: `CREATE DATABASE bd_tracking;`

### Erro: "relation does not exist"
- As tabelas serão criadas automaticamente na primeira execução
- Execute o backend uma vez para criar as tabelas

## 📝 Notas

- O sistema usa **SQLAlchemy ORM** para gerenciar o banco
- As tabelas são criadas automaticamente via `Base.metadata.create_all()`
- O pool de conexões está configurado para melhor performance
- SSL está desabilitado (`sslmode=disable`) - ajuste se necessário
