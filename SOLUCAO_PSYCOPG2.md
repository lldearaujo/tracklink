# 🔧 Solução: Erro ao Instalar psycopg2-binary no Windows

## ❌ Erro Comum

```
Error: pg_config executable not found.
pg_config is required to build psycopg2 from source.
ERROR: Failed to build 'psycopg2-binary' when getting requirements to build wheel
```

## 🔍 Causa

O `psycopg2-binary` está tentando compilar do código-fonte ao invés de usar os binários pré-compilados (wheels). Isso acontece quando:
- A versão específica não tem wheels para sua versão do Python
- O pip está tentando compilar ao invés de baixar wheels
- Cache do pip está corrompido

## ✅ Soluções

### Solução 1: Instalar com Script Especial (Recomendado)

Execute o script criado especificamente para isso:

```bash
instalar_psycopg2_windows.bat
```

Este script:
- ✅ Limpa o cache do pip
- ✅ Tenta instalar a versão mais recente
- ✅ Se falhar, tenta versões alternativas
- ✅ Testa se a instalação funcionou

### Solução 2: Instalar Manualmente

```bash
# Ativar ambiente virtual
venv\Scripts\activate.bat

# Limpar cache e instalar
pip install --no-cache-dir --upgrade pip
pip install --no-cache-dir psycopg2-binary
```

### Solução 3: Versão Específica que Funciona

Se as soluções acima não funcionarem, tente versões específicas:

```bash
venv\Scripts\activate.bat
pip install --no-cache-dir psycopg2-binary==2.9.8
```

Ou versão mais antiga:

```bash
pip install --no-cache-dir psycopg2-binary==2.9.7
```

### Solução 4: Instalar Visual C++ Build Tools

Se ainda não funcionar, pode ser necessário instalar as ferramentas de compilação:

1. Baixe: https://visualstudio.microsoft.com/visual-cpp-build-tools/
2. Instale "C++ build tools"
3. Reinicie o terminal
4. Tente instalar novamente

### Solução 5: Usar PostgreSQL Client Tools

Como última alternativa:

1. Instale PostgreSQL (mesmo que não vá usar o servidor):
   - https://www.postgresql.org/download/windows/
   - Durante instalação, marque "Command Line Tools"
   
2. Adicione ao PATH:
   - Normalmente: `C:\Program Files\PostgreSQL\XX\bin`
   
3. Tente instalar novamente

## 🧪 Verificar Instalação

Após instalar, teste se funcionou:

```bash
venv\Scripts\activate.bat
python -c "import psycopg2; print('psycopg2 instalado com sucesso!')"
```

## 📝 Continuar Instalação

Após instalar o psycopg2-binary com sucesso, continue com:

```bash
# Instalar outras dependências
pip install -r requirements.txt

# Ou executar setup.bat novamente (ele vai pular o que já está instalado)
setup.bat
```

## ⚠️ Dicas

1. **Sempre use `--no-cache-dir`** ao instalar psycopg2-binary no Windows
2. **Atualize o pip primeiro**: `pip install --upgrade pip`
3. **Use o script automático**: `instalar_psycopg2_windows.bat` já faz tudo isso
4. **Se falhar**, tente versões específicas (2.9.8, 2.9.7, etc.)

## 🆘 Ainda com Problemas?

1. Verifique sua versão do Python:
   ```bash
   python --version
   ```

2. Verifique se tem permissões de escrita na pasta `venv`

3. Tente criar um novo ambiente virtual:
   ```bash
   rmdir /s /q venv
   python -m venv venv
   venv\Scripts\activate.bat
   pip install --no-cache-dir psycopg2-binary
   ```
