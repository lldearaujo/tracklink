# Quick Start Guide

## Windows

### First Time Setup
```bash
setup.bat
```

### Start Everything
```bash
start_all.bat
```

### Access
- Dashboard: http://localhost:3000
- API Docs: http://localhost:8000/docs

## Linux/Mac

### First Time Setup
```bash
chmod +x *.sh
./setup.sh
```

### Start Everything
```bash
./start_all.sh
```

### Access
- Dashboard: http://localhost:3000
- API Docs: http://localhost:8000/docs

## Stop

**Windows:**
```bash
stop_all.bat
```

**Linux/Mac:**
```bash
pkill -f uvicorn
pkill -f react-scripts
```
