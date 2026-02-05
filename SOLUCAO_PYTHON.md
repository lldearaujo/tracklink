# 🔧 Solução: Python Não Encontrado

Se você está vendo o erro "Python não encontrado", siga estes passos:

## 🔍 Diagnóstico

Primeiro, execute o diagnóstico completo:

```bash
verificar_python.bat
```

Este script vai:
- ✅ Testar diferentes comandos (python, py, python3)
- ✅ Verificar o PATH do sistema
- ✅ Procurar Python em locais comuns

## ✅ Soluções

### Solução 1: Python não está instalado

**Instalar Python:**
1. Baixe de: https://www.python.org/downloads/
2. Durante a instalação, **MARQUE** a opção:
   - ✅ **"Add Python to PATH"** (muito importante!)
3. Complete a instalação
4. **Reinicie o terminal** completamente
5. Teste: `python --version`

### Solução 2: Python está instalado mas não no PATH

**Adicionar Python ao PATH manualmente:**

1. Encontre onde Python está instalado:
   - Normalmente: `C:\Python3XX\` ou `C:\Users\SeuUsuario\AppData\Local\Programs\Python\`

2. Adicione ao PATH:
   - Pressione `Win + R`
   - Digite: `sysdm.cpl` e Enter
   - Aba "Avançado" → "Variáveis de Ambiente"
   - Em "Variáveis do sistema", encontre "Path"
   - Clique "Editar" → "Novo"
   - Adicione: `C:\Python3XX\` e `C:\Python3XX\Scripts\`
   - Clique "OK" em todas as janelas
   - **Reinicie o terminal**

### Solução 3: Usar Python Launcher (py)

Se você tem Python instalado mas `python` não funciona, tente:

```bash
py --version
```

Se funcionar, o script `setup.bat` atualizado já detecta automaticamente!

### Solução 4: Python em local não padrão

Se Python está em um local específico:

1. Execute o Python diretamente:
   ```bash
   C:\caminho\para\python.exe --version
   ```

2. Ou adicione esse caminho ao PATH (veja Solução 2)

## 🧪 Testar

Após aplicar uma solução:

```bash
# Teste rápido
testar_python.bat

# Ou teste manualmente
python --version
# ou
py --version
```

## 📝 Verificar Instalação

Para verificar se Python está realmente instalado:

```bash
# Verificar em locais comuns
dir C:\Python*
dir "%LOCALAPPDATA%\Programs\Python"
dir "%ProgramFiles%\Python*"
```

## ⚠️ Dicas Importantes

1. **Sempre marque "Add Python to PATH"** durante a instalação
2. **Reinicie o terminal** após instalar ou modificar PATH
3. Use `verificar_python.bat` para diagnóstico completo
4. O script `setup.bat` atualizado tenta detectar automaticamente (python, py, python3)

## 🆘 Ainda com Problemas?

1. Execute `verificar_python.bat` e envie o resultado
2. Verifique se Python está instalado: `where python`
3. Tente executar Python diretamente pelo caminho completo
4. Verifique se há múltiplas versões do Python instaladas
