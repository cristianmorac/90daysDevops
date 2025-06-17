#!/bin/bash
set -e
# Directorio .ssh
SSH_DIR="$HOME/.ssh"
KEY_FILE="$SSH_DIR/id_rsa"

# Crear .ssh si no existe
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Crear la llave si no existe
if [ ! -f "$KEY_FILE" ]; then
  echo "🔐 Generando llave SSH para el usuario $(whoami)..."
  ssh-keygen -t rsa -b 4096 -f "$KEY_FILE" -q -N ""
else
  echo "✅ Llave SSH ya existe en $KEY_FILE"
fi

# Permisos seguros
chmod 600 "$KEY_FILE"
chmod 644 "$KEY_FILE.pub"
