FROM python:3.12-slim

# Não gerar .pyc e sempre mostrar logs imediatamente
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Dependências de sistema necessárias para algumas libs (ex: psycopg2)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
 && rm -rf /var/lib/apt/lists/*

# Instalar dependências Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código do backend
COPY backend ./backend

# Entrar na pasta backend (onde está main.py e o pacote app/)
WORKDIR /app/backend

# Porta exposta pelo FastAPI/Uvicorn
EXPOSE 8000

# Comando para iniciar a API
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

