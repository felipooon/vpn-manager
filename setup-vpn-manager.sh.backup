#!/bin/bash

# Script de configuración inicial para VPN Manager
# Uso: ./setup-vpn-manager.sh

set -e

echo "=== Configuración inicial de VPN Manager ==="
echo ""

# Verificar si está en Ubuntu/Debian
if ! command -v apt &> /dev/null; then
    echo "❌ Este script está diseñado para sistemas Ubuntu/Debian"
    exit 1
fi

# Instalar dependencias
echo "📦 Instalando dependencias..."
sudo apt update
sudo apt install -y sshfs encfs python3

# Crear directorios necesarios
echo "📁 Creando directorios..."
mkdir -p "$HOME/vpnadmin/VPN-encrypted"
mkdir -p "$HOME/vpnadmin/VPN"

# Verificar que vpn-manager.sh existe
if [ ! -f "$HOME/vpnadmin/vpn-manager.sh" ]; then
    echo "❌ No se encontró vpn-manager.sh en $HOME/vpnadmin/"
    echo "   Asegúrate de tener el script principal en el directorio correcto"
    exit 1
fi

# Hacer ejecutable el script principal
chmod +x "$HOME/vpnadmin/vpn-manager.sh"

# Agregar alias si no existen
if ! grep -q "vpn-help" ~/.zshrc 2>/dev/null && ! grep -q "vpn-help" ~/.bashrc 2>/dev/null; then
    echo "🔗 Agregando alias..."
    
    # Detectar shell
    if [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/bin/zsh" ]; then
        SHELL_RC="$HOME/.zshrc"
    else
        SHELL_RC="$HOME/.bashrc"
    fi
    
    cat >> "$SHELL_RC" << 'EOF'

# VPN Management Aliases
alias vpn-help="$HOME/vpnadmin/vpn-manager.sh help"
alias vpn-status="$HOME/vpnadmin/vpn-manager.sh status"
alias vpn-mount="$HOME/vpnadmin/vpn-manager.sh mount"
alias vpn-decrypt="$HOME/vpnadmin/vpn-manager.sh decrypt"
alias vpn-list="$HOME/vpnadmin/vpn-manager.sh list"
alias vpn-create="$HOME/vpnadmin/vpn-manager.sh create"
alias vpn-package="$HOME/vpnadmin/vpn-manager.sh package"
alias vpn-unmount="$HOME/vpnadmin/vpn-manager.sh unmount"
alias vpn-full="$HOME/vpnadmin/vpn-manager.sh full"
alias vpnmgr="$HOME/vpnadmin/vpn-manager.sh"
EOF
    
    echo "   Alias agregados a $SHELL_RC"
else
    echo "🔗 Alias ya configurados"
fi

# Obtener información del usuario
USER_ID=$(id -u)
GROUP_ID=$(id -g)

echo ""
echo "✅ Configuración completada!"
echo ""
echo "📋 Información de tu sistema:"
echo "   UID: $USER_ID"
echo "   GID: $GROUP_ID"
echo "   Directorio base: $HOME/vpnadmin"
echo ""
echo "🚀 Comandos disponibles:"
echo "   vpn-help          - Mostrar ayuda"
echo "   vpn-status        - Ver estado"
echo "   vpn-mount [user]  - Montar directorio"
echo "   vpn-full [user] [client] - Proceso completo"
echo ""
echo "📌 Para usar los alias, ejecuta:"
echo "   source ~/.$(basename $SHELL)rc"
echo ""
echo "🔑 Recuerda conseguir la contraseña de descifrado con Pablo Santamarina"
