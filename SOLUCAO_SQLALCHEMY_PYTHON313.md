# 🔧 Solução: Erro SQLAlchemy com Python 3.13

## ❌ Erro

```
AssertionError: Class <class 'sqlalchemy.sql.elements.SQLCoreOperations'> directly inherits TypingOnly but has additional attributes {'__firstlineno__', '__static_attributes__'}.
```

## 🔍 Causa

O **SQLAlchemy 2.0.23** não é totalmente compatível com **Python 3.13**. O Python 3.13 introduziu mudanças no sistema de tipos que causam conflitos com versões antigas do SQLAlchemy.

## ✅ Solução

### Opção 1: Atualizar SQLAlchemy (Recomendado)

Execute o script criado:

```bash
atualizar_sqlalchemy.bat
```

Este script:
- ✅ Desinstala SQLAlchemy antigo
- ✅ Instala versão compatível (>=2.0.36)
- ✅ Verifica se funcionou

### Opção 2: Atualizar Manualmente

```bash
venv\Scripts\activate.bat
pip uninstall -y sqlalchemy
pip install --upgrade "sqlalchemy>=2.0.36"
```

### Opção 3: Atualizar Todas as Dependências

```bash
venv\Scripts\activate.bat
pip install --upgrade -r requirements.txt
```

## 📝 O Que Foi Atualizado

- `requirements.txt` - SQLAlchemy atualizado para `>=2.0.36` (compatível com Python 3.13)
- `atualizar_sqlalchemy.bat` - Script para atualizar automaticamente

## 🧪 Verificar

Após atualizar, teste:

```bash
venv\Scripts\activate.bat
python -c "import sqlalchemy; print('SQLAlchemy', sqlalchemy.__version__)"
```

## 🚀 Após Corrigir

Depois de atualizar o SQLAlchemy, inicie o backend:

```bash
start_backend.bat
```

Ou manualmente:

```bash
venv\Scripts\activate.bat
cd backend
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

## ⚠️ Nota

Se ainda der erro após atualizar, pode ser necessário:
1. Limpar cache do pip: `pip cache purge`
2. Reinstalar: `pip uninstall -y sqlalchemy && pip install sqlalchemy`
3. Verificar versão do Python: `python --version` (Python 3.13 pode ter outras incompatibilidades)

## 🆘 Alternativa: Usar Python 3.11 ou 3.12

Se os problemas persistirem, considere usar Python 3.11 ou 3.12, que têm melhor compatibilidade com todas as bibliotecas:

1. Instale Python 3.11 ou 3.12
2. Recrie o ambiente virtual:
   ```bash
   rmdir /s /q venv
   py -3.11 -m venv venv
   venv\Scripts\activate.bat
   pip install -r requirements.txt
   ```
