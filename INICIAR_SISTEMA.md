# 🚀 Como Iniciar o Sistema Completo

## ⚡ Início Rápido

### Iniciar Tudo de Uma Vez (No Terminal do Cursor)

Execute:

```bash
start_all.bat
```

Isso vai:
- ✅ Iniciar o **Backend** em background (porta 8000)
- ✅ Iniciar o **Frontend** em background (porta 3000)
- ✅ Manter tudo rodando no mesmo terminal
- ✅ Você pode continuar usando o terminal normalmente

### Acessar

Após iniciar, acesse:

- **Dashboard**: http://localhost:3000
- **API Docs**: http://localhost:8000/docs
- **Backend**: http://localhost:8000

## 🛑 Parar o Sistema

### Opção 1: Script Automático

```bash
stop_all.bat
```

### Opção 2: Manualmente

1. Feche as janelas do Backend e Frontend
2. Ou pressione `Ctrl+C` em cada janela

## 📝 Iniciar Separadamente

Se preferir iniciar um de cada vez:

### Backend Apenas

```bash
start_backend.bat
```

### Frontend Apenas

```bash
start_frontend.bat
```

## ⚠️ Importante

- **Mantenha ambas as janelas abertas** enquanto usar o sistema
- O backend deve iniciar primeiro (aguarda 5 segundos)
- Se o frontend não conectar ao backend, verifique se o backend está rodando
- Para parar tudo, use `stop_all.bat` ou feche as janelas

## 🔍 Verificar se Está Funcionando

1. **Backend**: Acesse http://localhost:8000/docs
   - Deve mostrar a documentação da API

2. **Frontend**: Acesse http://localhost:3000
   - Deve mostrar o dashboard

3. **Health Check**: http://localhost:8000/health
   - Deve retornar: `{"status": "healthy"}`

## 🐛 Problemas Comuns

### Backend não inicia
- Verifique se o ambiente virtual está configurado: `setup.bat`
- Verifique se as dependências estão instaladas
- Verifique se a porta 8000 está livre

### Frontend não inicia
- Verifique se Node.js está instalado
- Verifique se as dependências estão instaladas: `cd frontend && npm install`
- Verifique se a porta 3000 está livre

### Frontend não conecta ao Backend
- Verifique se o backend está rodando
- Verifique se o backend está na porta 8000
- Verifique o console do navegador para erros
