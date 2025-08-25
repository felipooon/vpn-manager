#!/bin/bash

# Script para automatizar la gestión de VPNs OpenVPN
# Uso: ./vpn-manager.sh [comando] [opciones]

set -e

# Configuración
VPN_BASE_DIR="$HOME/vpnadmin"
VPN_ENCRYPTED_DIR="$VPN_BASE_DIR/VPN-encrypted"
VPN_DECRYPTED_DIR="$VPN_BASE_DIR/VPN"
SERVER_HOST="intranet.innovex.cl"
SERVER_PATH="/home/pablo/vpnadmin/VPN-encrypted"
USER_ID=$(id -u)
GROUP_ID=$(id -g)

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar ayuda
show_help() {
    echo -e "${BLUE}VPN Manager - OpenVPN Key Management Tool${NC}"
    echo ""
    echo "Uso: $0 [comando] [opciones]"
    echo ""
    echo "Comandos:"
    echo "  mount [usuario]      - Montar directorio encriptado del servidor"
    echo "  decrypt              - Descifrar directorio local"
    echo "  list                 - Listar clientes VPN existentes"
    echo "  create [nombre]      - Crear nuevas credenciales VPN"
    echo "  package [nombre]     - Crear tar-file para cliente específico"
    echo "  unmount              - Desmontar directorios"
    echo "  status               - Verificar estado de montaje"
    echo "  full [usuario] [nombre] - Proceso completo para crear VPN"
    echo "  help                 - Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0 mount juan.perez"
    echo "  $0 full juan.perez inn-saturno"
    echo "  $0 create inn-jupiter"
    echo ""
}

# Función para verificar si está montado
is_mounted() {
    mountpoint -q "$1" 2>/dev/null
}

# Función para montar directorio encriptado
mount_encrypted() {
    local username="$1"
    
    if [ -z "$username" ]; then
        echo -e "${RED}Error: Debes especificar tu nombre de usuario del servidor${NC}"
        echo "Uso: $0 mount [usuario]"
        exit 1
    fi
    
    if is_mounted "$VPN_ENCRYPTED_DIR"; then
        echo -e "${YELLOW}El directorio encriptado ya está montado${NC}"
        return 0
    fi
    
    echo -e "${BLUE}Montando directorio encriptado...${NC}"
    sshfs -o "uid=$USER_ID" -o "gid=$GROUP_ID" \
          "$username@$SERVER_HOST:$SERVER_PATH" \
          "$VPN_ENCRYPTED_DIR"
    
    if is_mounted "$VPN_ENCRYPTED_DIR"; then
        echo -e "${GREEN}✓ Directorio encriptado montado correctamente${NC}"
        echo "Archivos encontrados:"
        ls "$VPN_ENCRYPTED_DIR" | head -5
        echo "..."
    else
        echo -e "${RED}✗ Error al montar directorio encriptado${NC}"
        exit 1
    fi
}

# Función para descifrar directorio
decrypt_directory() {
    if ! is_mounted "$VPN_ENCRYPTED_DIR"; then
        echo -e "${RED}Error: Primero debes montar el directorio encriptado${NC}"
        echo "Usa: $0 mount [usuario]"
        exit 1
    fi
    
    if is_mounted "$VPN_DECRYPTED_DIR"; then
        echo -e "${YELLOW}El directorio ya está descifrado${NC}"
        return 0
    fi
    
    echo -e "${BLUE}Descifrando directorio...${NC}"
    echo -e "${YELLOW}Se te pedirá la contraseña de descifrado (conseguir con Pablo Santamarina)${NC}"
    
    encfs "$VPN_ENCRYPTED_DIR" "$VPN_DECRYPTED_DIR"
    
    if is_mounted "$VPN_DECRYPTED_DIR"; then
        echo -e "${GREEN}✓ Directorio descifrado correctamente${NC}"
    else
        echo -e "${RED}✗ Error al descifrar directorio${NC}"
        exit 1
    fi
}

# Función para listar clientes existentes
list_clients() {
    if ! is_mounted "$VPN_DECRYPTED_DIR"; then
        echo -e "${RED}Error: El directorio no está descifrado${NC}"
        echo "Usa primero: $0 decrypt"
        exit 1
    fi
    
    if [ -f "$VPN_DECRYPTED_DIR/openvpn/all_openvpn_clients" ]; then
        echo -e "${BLUE}Clientes VPN existentes:${NC}"
        cat "$VPN_DECRYPTED_DIR/openvpn/all_openvpn_clients"
    else
        echo -e "${YELLOW}No se encontró el archivo de clientes${NC}"
    fi
}

# Función para crear credenciales
create_credentials() {
    local client_name="$1"
    
    if [ -z "$client_name" ]; then
        echo -e "${RED}Error: Debes especificar el nombre del cliente${NC}"
        echo "Uso: $0 create [nombre_cliente]"
        exit 1
    fi
    
    if ! is_mounted "$VPN_DECRYPTED_DIR"; then
        echo -e "${RED}Error: El directorio no está descifrado${NC}"
        exit 1
    fi
    
    cd "$VPN_DECRYPTED_DIR"
    
    echo -e "${BLUE}Creando credenciales para: ${YELLOW}$client_name${NC}"
    
    if ./create_keys "$client_name"; then
        echo -e "${GREEN}✓ Credenciales creadas exitosamente para $client_name${NC}"
    else
        echo -e "${RED}✗ Error al crear credenciales${NC}"
        exit 1
    fi
}

# Función para crear tar-file
create_package() {
    local client_name="$1"
    
    if [ -z "$client_name" ]; then
        echo -e "${RED}Error: Debes especificar el nombre del cliente${NC}"
        echo "Uso: $0 package [nombre_cliente]"
        exit 1
    fi
    
    if ! is_mounted "$VPN_DECRYPTED_DIR"; then
        echo -e "${RED}Error: El directorio no está descifrado${NC}"
        exit 1
    fi
    
    cd "$VPN_DECRYPTED_DIR"
    
    echo -e "${BLUE}Creando paquete tar para: ${YELLOW}$client_name${NC}"
    
    if ./create_vpn_tarfile "$client_name"; then
        echo -e "${GREEN}✓ Paquete tar creado exitosamente${NC}"
        echo -e "${BLUE}Archivo creado en: ${YELLOW}$VPN_BASE_DIR/$client_name.tar.gz${NC}"
        
        if [ -f "$VPN_BASE_DIR/$client_name.tar.gz" ]; then
            ls -lh "$VPN_BASE_DIR/$client_name.tar.gz"
        fi
    else
        echo -e "${RED}✗ Error al crear paquete tar${NC}"
        exit 1
    fi
}

# Función para desmontar
unmount_all() {
    echo -e "${BLUE}Desmontando directorios...${NC}"
    
    if is_mounted "$VPN_DECRYPTED_DIR"; then
        umount "$VPN_DECRYPTED_DIR" && echo -e "${GREEN}✓ Directorio descifrado desmontado${NC}"
    fi
    
    if is_mounted "$VPN_ENCRYPTED_DIR"; then
        umount "$VPN_ENCRYPTED_DIR" && echo -e "${GREEN}✓ Directorio encriptado desmontado${NC}"
    fi
    
    echo -e "${GREEN}✓ Proceso de desmontaje completado${NC}"
}

# Función para verificar estado
check_status() {
    echo -e "${BLUE}Estado del sistema VPN:${NC}"
    
    if is_mounted "$VPN_ENCRYPTED_DIR"; then
        echo -e "${GREEN}✓ Directorio encriptado: MONTADO${NC}"
    else
        echo -e "${RED}✗ Directorio encriptado: NO MONTADO${NC}"
    fi
    
    if is_mounted "$VPN_DECRYPTED_DIR"; then
        echo -e "${GREEN}✓ Directorio descifrado: MONTADO${NC}"
    else
        echo -e "${RED}✗ Directorio descifrado: NO MONTADO${NC}"
    fi
}

# Función para proceso completo
full_process() {
    local username="$1"
    local client_name="$2"
    
    if [ -z "$username" ] || [ -z "$client_name" ]; then
        echo -e "${RED}Error: Debes especificar usuario y nombre del cliente${NC}"
        echo "Uso: $0 full [usuario_servidor] [nombre_cliente]"
        exit 1
    fi
    
    echo -e "${BLUE}=== Proceso completo para crear VPN ===${NC}"
    echo -e "${BLUE}Usuario: ${YELLOW}$username${NC}"
    echo -e "${BLUE}Cliente: ${YELLOW}$client_name${NC}"
    echo ""
    
    mount_encrypted "$username"
    decrypt_directory
    create_credentials "$client_name"
    create_package "$client_name"
    
    echo ""
    echo -e "${GREEN}=== Proceso completado exitosamente ===${NC}"
    echo -e "${YELLOW}No olvides desmontar con: vpn-unmount${NC}"
}

# Función principal
main() {
    case "${1:-help}" in
        "mount")
            mount_encrypted "$2"
            ;;
        "decrypt")
            decrypt_directory
            ;;
        "list")
            list_clients
            ;;
        "create")
            create_credentials "$2"
            ;;
        "package")
            create_package "$2"
            ;;
        "unmount")
            unmount_all
            ;;
        "status")
            check_status
            ;;
        "full")
            full_process "$2" "$3"
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            echo -e "${RED}Comando desconocido: $1${NC}"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

main "$@"
