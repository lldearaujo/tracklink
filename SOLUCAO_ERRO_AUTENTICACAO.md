# 🔧 Solução: Erro de Autenticação no PostgreSQL

## ❌ Erro

```
psycopg2.OperationalError: connection to server at "72.60.63.29", port 32541 failed: 
FATAL: password authentication failed for user "tracking"
```

## 🔍 Causa

A senha no arquivo de configuração está incorreta ou há um problema de autenticação com o PostgreSQL.

## ✅ Soluções

### Solução 1: Script Automático (Recomendado)

Execute o script criado para corrigir as credenciais:

```bash
corrigir_credenciais_banco.bat
```

Este script permite:
- ✅ Testar a conexão atual
- ✅ Ver as credenciais configuradas
- ✅ Criar/editar o arquivo .env
- ✅ Testar diferentes senhas

### Solução 2: Verificar Credenciais Manualmente

1. **Verifique o arquivo `backend/.env`**:
   ```env
   DATABASE_URL=postgresql://tracking:S3v3r1n0_01@72.60.63.29:32541/bd_tracking?sslmode=disable
   ```

2. **Confirme as credenciais**:
   - **Usuário**: `tracking`
   - **Senha**: Pode ser `S3v3r1n0_01` ou `S3v3r1n0_o1` (verifique qual está correta)
   - **Host**: `72.60.63.29`
   - **Porta**: `32541`
   - **Banco**: `bd_tracking`

### Solução 2: Testar Conexão

Execute o script de teste:

```bash
testar_conexao_banco.bat
```

Este script vai:
- ✅ Tentar conectar ao banco
- ✅ Mostrar o erro específico
- ✅ Verificar se as credenciais estão corretas

### Solução 3: Corrigir Senha no .env

Se a senha estiver incorreta, edite `backend/.env`:

1. Abra o arquivo `backend/.env`
2. Verifique a linha `DATABASE_URL`
3. Corrija a senha se necessário
4. **Importante**: Se a senha tiver caracteres especiais, pode precisar ser URL-encoded:
   - `_` (underscore) = `_` ou `%5F`
   - `@` = `%40`
   - `#` = `%23`
   - etc.

### Solução 4: Verificar Senha na Imagem Fornecida

Baseado na imagem que você forneceu:
- **Senha mostrada**: `S3v3r1n0_01`
- **URL interna**: `S3v3r1n0_o1` (com "o" minúsculo)

**Verifique qual é a senha correta!**

### Solução 5: Usar URL de Conexão Interna

Se você estiver na mesma rede, tente a URL interna:

Edite `backend/.env`:
```env
DATABASE_URL=postgresql://tracking:S3v3r1n0_01@outdoora_bd_tracking:5432/bd_tracking?sslmode=disable
```

## 🧪 Testar Manualmente

```bash
venv\Scripts\activate.bat
cd backend
python -c "from app.core.database import engine; conn = engine.connect(); print('OK!'); conn.close()"
```

## 📝 Nota sobre o Backend

O backend foi modificado para **não falhar na inicialização** se o banco não estiver acessível. Ele vai:
- ✅ Iniciar normalmente
- ⚠️ Mostrar um aviso sobre a conexão
- ✅ Permitir que você corrija as credenciais sem reiniciar

## 🔒 Verificar Credenciais

Execute para ver as credenciais configuradas:

```bash
venv\Scripts\activate.bat
cd backend
python -c "from app.core.config import settings; print('DATABASE_URL:', settings.DATABASE_URL.replace(settings.DATABASE_URL.split('@')[0].split('://')[1].split(':')[1], '***'))"
```

Ou simplesmente abra o arquivo `backend/.env` e verifique manualmente.

## 🆘 Ainda com Problemas?

1. **Verifique se o servidor PostgreSQL está acessível**:
   - Teste com um cliente PostgreSQL (pgAdmin, DBeaver)
   - Verifique firewall/rede

2. **Verifique se o usuário existe**:
   - O usuário `tracking` deve existir no servidor
   - Deve ter permissões no banco `bd_tracking`

3. **Verifique a senha**:
   - Confirme com o administrador do banco
   - Pode ter sido alterada recentemente

4. **Teste com psql** (se tiver acesso):
   ```bash
   psql -h 72.60.63.29 -p 32541 -U tracking -d bd_tracking
   ```
