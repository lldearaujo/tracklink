# 🔧 Solução: Erro de Compilação do pydantic-core (Rust)

## ❌ Erro Comum

```
error: metadata-generation-failed
× Encountered error while generating package metadata.
╰─> pydantic-core
Cargo, the Rust package manager, is not installed or is not on PATH.
This package requires Rust and Cargo to compile extensions.
```

## 🔍 Causa

O `pydantic-core` está tentando compilar do código-fonte e precisa do Rust, que não está instalado. Isso acontece quando:
- O pip não encontra wheels pré-compilados para sua versão do Python
- A versão do Python é muito nova e ainda não tem wheels disponíveis
- O cache do pip está forçando compilação

## ✅ Soluções

### Solução 1: Script Automático (Recomendado)

Execute o script criado que instala apenas wheels pré-compilados:

```bash
instalar_dependencias_windows.bat
```

Este script:
- ✅ Instala apenas wheels pré-compilados (evita compilação)
- ✅ Tenta versões alternativas se necessário
- ✅ Verifica se a instalação funcionou

### Solução 2: Forçar Apenas Wheels

Instale forçando apenas wheels pré-compilados:

```bash
venv\Scripts\activate.bat
pip install --upgrade pip
pip install --only-binary :all: --no-cache-dir -r requirements.txt
```

### Solução 3: Instalar Rust (Se Quiser Compilar)

Se preferir instalar Rust para compilar:

1. Baixe Rust: https://rustup.rs/
2. Execute o instalador
3. Reinicie o terminal
4. Tente instalar novamente

**Nota:** Isso é desnecessário se usar wheels pré-compilados.

### Solução 4: Versões Específicas com Wheels

Se ainda não funcionar, use versões específicas que têm wheels:

```bash
venv\Scripts\activate.bat
pip install --no-cache-dir pydantic-core==2.23.0
pip install --no-cache-dir "pydantic>=2.4.0,<3.0.0"
pip install --no-cache-dir -r requirements.txt
```

### Solução 5: Usar Python 3.11 ou 3.12

Se você está usando Python 3.13 (muito novo), pode não ter wheels disponíveis ainda. Tente:

- Python 3.11 ou 3.12 (têm mais wheels disponíveis)
- Ou aguarde até que wheels sejam disponibilizados

## 🧪 Verificar Instalação

Após instalar, teste:

```bash
venv\Scripts\activate.bat
python -c "import pydantic; print('Pydantic OK!')"
python -c "import fastapi; print('FastAPI OK!')"
python -c "import psycopg2; print('psycopg2 OK!')"
```

## 📝 Ordem Recomendada de Instalação

1. **Primeiro**: `instalar_dependencias_windows.bat`
2. **Se falhar**: Tente manualmente com `--only-binary :all:`
3. **Último recurso**: Instalar Rust e compilar

## ⚠️ Dicas Importantes

1. **Sempre use `--no-cache-dir`** para evitar cache corrompido
2. **Use `--only-binary :all:`** para forçar apenas wheels
3. **Atualize o pip primeiro**: `pip install --upgrade pip`
4. **Python 3.11/3.12** têm melhor suporte de wheels

## 🆘 Ainda com Problemas?

1. Verifique sua versão do Python:
   ```bash
   python --version
   ```
   Se for 3.13, considere usar 3.11 ou 3.12

2. Limpe completamente o ambiente:
   ```bash
   rmdir /s /q venv
   python -m venv venv
   venv\Scripts\activate.bat
   pip install --upgrade pip
   pip install --only-binary :all: --no-cache-dir -r requirements.txt
   ```

3. Use o script automático que já faz tudo isso:
   ```bash
   instalar_dependencias_windows.bat
   ```
