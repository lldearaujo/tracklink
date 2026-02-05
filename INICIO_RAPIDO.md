# ⚡ Início Rápido

## 🚀 Para Começar Agora (Windows)

> 💡 **Você já tem Python instalado?** Veja [JA_TEM_PYTHON.md](JA_TEM_PYTHON.md) para um guia ainda mais rápido!

### 1. Configuração Inicial (Apenas Primeira Vez)

```bash
setup.bat
```

Este comando irá:
- ✅ Verificar Python e Node.js
- ✅ Criar ambiente virtual (isolado)
- ✅ Instalar todas as dependências

### 2. Iniciar o Sistema

```bash
start_all.bat
```

Isso abrirá automaticamente:
- **Backend** na porta 8000
- **Frontend** na porta 3000

### 3. Acessar

Abra seu navegador em:
- **Dashboard**: http://localhost:3000
- **API Docs**: http://localhost:8000/docs

## 📝 Primeiro Teste

1. **Testar conexão com banco** (opcional):
   ```bash
   testar_conexao_db.bat
   ```

2. Acesse http://localhost:3000
3. Clique em **"Criar Novo Link"**
4. Preencha:
   - Identificador: `teste-001`
   - URL: `https://google.com`
   - Ponto DOOH: `Shopping Teste`
   - Campanha: `Teste Inicial`
5. Clique em **"Criar Link"**
6. Copie o link rastreável gerado
7. Abra o link em uma nova aba
8. Volte ao dashboard e veja os dados!

> 💡 **Nota**: Os dados são salvos no PostgreSQL configurado. Veja [CONFIGURACAO_BANCO.md](CONFIGURACAO_BANCO.md) para mais detalhes.

## 🛑 Parar o Sistema

```bash
stop_all.bat
```

Ou feche as janelas dos servidores (Ctrl+C).

## ❓ Problemas?

Execute para verificar:
```bash
verificar_ambiente.bat
```

---

**Para mais detalhes, veja [GUIA_EXECUCAO.md](GUIA_EXECUCAO.md)**
