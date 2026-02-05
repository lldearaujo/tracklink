# ✅ Você Já Tem Python Instalado!

Perfeito! Como você já tem Python instalado, o processo será ainda mais rápido.

## 🚀 Início Rápido

### 1. Verificar Python (Opcional)

Se quiser testar se o Python está funcionando:

```bash
testar_python.bat
```

### 2. Configurar o Ambiente

Execute apenas uma vez:

```bash
setup.bat
```

Este script irá:
- ✅ Detectar seu Python instalado
- ✅ Criar ambiente virtual (venv)
- ✅ Instalar dependências do backend
- ✅ Verificar Node.js
- ✅ Instalar dependências do frontend

### 3. Iniciar o Sistema

```bash
start_all.bat
```

Pronto! O sistema estará rodando em:
- **Dashboard**: http://localhost:3000
- **API**: http://localhost:8000
- **Docs**: http://localhost:8000/docs

## 📝 O Que Acontece

1. **Ambiente Virtual**: Será criado na pasta `venv/` (isolado do seu Python global)
2. **Dependências**: Instaladas apenas no ambiente virtual
3. **Banco de Dados**: Criado automaticamente na primeira execução

## ⚡ Comandos Úteis

```bash
# Verificar se tudo está OK
verificar_ambiente.bat

# Iniciar apenas backend
start_backend.bat

# Iniciar apenas frontend
start_frontend.bat

# Parar tudo
stop_all.bat
```

## 🔍 Se Algo Der Errado

### Python não detectado
- Verifique se Python está no PATH: `python --version`
- Tente: `py --version` (Python Launcher do Windows)

### Erro ao criar ambiente virtual
- Certifique-se de ter permissões de escrita na pasta
- Tente executar como administrador

### Dependências não instalam
- Verifique sua conexão com internet
- Tente: `pip install --upgrade pip` manualmente

## 💡 Dica

O ambiente virtual (`venv`) é isolado - não interfere com outros projetos Python que você tenha!
