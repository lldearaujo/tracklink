# 🔧 Problemas de Conexão com Banco de Dados

## ✅ Credenciais Estão Corretas, Mas Não Conecta?

Se você confirmou que as credenciais estão corretas mas ainda há erro de autenticação, pode ser:

### 1. 🔒 Firewall Bloqueando

O servidor PostgreSQL pode estar bloqueando conexões externas.

**Solução:**
- Verifique se o firewall permite conexões na porta 32541
- Verifique se o PostgreSQL está configurado para aceitar conexões externas
- Pode ser necessário adicionar seu IP à whitelist do PostgreSQL

### 2. 🌐 Problema de Rede

A conexão pode estar sendo bloqueada pela rede.

**Solução:**
- Teste de outra máquina/rede
- Verifique se precisa de VPN
- Verifique se precisa de túnel SSH

### 3. 📝 Formato da URL

Caracteres especiais na senha podem precisar ser URL-encoded.

**Solução:**
Execute o diagnóstico:
```bash
diagnostico_banco.bat
```

Ou teste diretamente:
```bash
testar_conexao_direta.bat
```

### 4. 🔐 Permissões do Usuário

O usuário pode não ter permissão para conexões remotas.

**Solução:**
- Verifique com o administrador do banco
- O usuário pode precisar de permissões específicas
- Pode ser necessário usar outro usuário

### 5. 🚫 Servidor Não Aceita Conexões Externas

O PostgreSQL pode estar configurado apenas para conexões locais.

**Solução:**
- Verifique o arquivo `pg_hba.conf` no servidor
- Verifique o arquivo `postgresql.conf` (listen_addresses)
- Pode ser necessário configurar o servidor para aceitar conexões externas

## 🧪 Scripts de Diagnóstico

### Diagnóstico Completo

```bash
diagnostico_banco.bat
```

Testa:
- ✅ Diferentes formatos de URL
- ✅ Diferentes senhas
- ✅ URL interna vs externa
- ✅ Conectividade de rede
- ✅ Atualiza automaticamente o .env se encontrar uma conexão que funciona

### Teste Direto

```bash
testar_conexao_direta.bat
```

Testa conexão direta com psycopg2, mostrando erros detalhados.

## 🔍 Verificar Manualmente

### Com Cliente PostgreSQL

Use um cliente como pgAdmin ou DBeaver para testar:

1. **pgAdmin**: https://www.pgadmin.org/
2. **DBeaver**: https://dbeaver.io/

Configure com:
- Host: `72.60.63.29`
- Port: `32541`
- Database: `bd_tracking`
- Username: `tracking`
- Password: `S3v3r1n0_01` (ou a correta)

### Com psql (se tiver instalado)

```bash
psql -h 72.60.63.29 -p 32541 -U tracking -d bd_tracking
```

## 💡 Soluções Alternativas

### Opção 1: Usar URL Interna

Se você estiver na mesma rede, tente a URL interna:

Edite `backend/.env`:
```env
DATABASE_URL=postgresql://tracking:S3v3r1n0_01@outdoora_bd_tracking:5432/bd_tracking?sslmode=disable
```

### Opção 2: Verificar com Administrador

Entre em contato com o administrador do banco e confirme:
- ✅ As credenciais estão corretas
- ✅ O servidor aceita conexões externas
- ✅ Seu IP está na whitelist
- ✅ A porta 32541 está aberta
- ✅ Não precisa de VPN ou túnel

### Opção 3: Usar Túnel SSH

Se o servidor só aceita conexões locais, você pode criar um túnel SSH:

```bash
ssh -L 5432:outdoora_bd_tracking:5432 usuario@servidor
```

Depois use:
```env
DATABASE_URL=postgresql://tracking:S3v3r1n0_01@localhost:5432/bd_tracking?sslmode=disable
```

## 📝 Nota Importante

O sistema **continua funcionando** mesmo sem conexão com o banco:
- ✅ Frontend funciona normalmente
- ✅ API responde (mas operações de banco falham)
- ✅ Você pode corrigir as credenciais sem reiniciar
- ⚠️ Apenas operações que precisam do banco não funcionarão

## 🆘 Ainda com Problemas?

1. Execute `diagnostico_banco.bat` e compartilhe o resultado
2. Teste com um cliente PostgreSQL (pgAdmin/DBeaver)
3. Verifique com o administrador do banco
4. Verifique logs do servidor PostgreSQL
