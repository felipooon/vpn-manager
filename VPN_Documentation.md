# OpenVPN Manager Documentation

**Versión:** 1.0  
**Fecha:** Agosto 2025  
**Autor:** Sistema Automatizado VPN Manager  

---

## 📋 Índice

1. [Introducción](#introducción)
2. [Requerimientos](#requerimientos)
3. [Instalación y Configuración](#instalación-y-configuración)
4. [Uso del Sistema](#uso-del-sistema)
5. [Comandos Disponibles](#comandos-disponibles)
6. [Ejemplos Prácticos](#ejemplos-prácticos)
7. [Solución de Problemas](#solución-de-problemas)
8. [Scripts Técnicos](#scripts-técnicos)

---

## 🌐 Introducción

OpenVPN es un sistema que permite mantener una red privada virtual (Virtual Private Network) entre computadores que pueden estar muy distanciados. Toda la comunicación entre los computadores se hace encriptada y todos los computadores que participan en la red virtual reciben direcciones IP de la misma base y quedan conectados en la misma red.

### ¿Por qué VPN Manager?

El **VPN Manager** es un sistema automatizado que simplifica completamente el proceso de creación de nuevas VPNs, reduciendo el proceso manual de múltiples pasos a un solo comando.

**Beneficios:**
- ✅ Automatización completa del proceso
- ✅ Validación de errores en cada paso
- ✅ Interface amigable con colores y feedback
- ✅ Comandos simples y memorables
- ✅ Manejo seguro de montaje y desmontaje

---

## 🔧 Requerimientos

### Sistema OpenVPN

Para usar OpenVPN necesitas:

```bash
apt install openvpn
```

### Archivos Necesarios

- **Credenciales**: Generadas por la autoridad certificadora (CA)
  - Archivo de clave: `.key`
  - Certificado: `.crt`
- **Certificado CA**: `ca.crt`
- **Archivo de configuración**: `.conf`

### Requerimientos del Computador Local

**Programas requeridos** (instalables con `apt install`):
- `sshfs` - Para montar directorios remotos
- `encfs` - Para descifrar directorios
- `python3` - Para ejecutar scripts de creación

**Permisos necesarios:**
- Usuario debe estar en el grupo `vpnadmin`
- Acceso SSH al servidor `intranet.innovex.cl`
- Contraseña de descifrado (proporcionada por Pablo Santamarina)

---

## 🚀 Instalación y Configuración

### Instalación Automática

Si ya tienes los scripts, ejecuta:

```bash
~/vpnadmin/setup-vpn-manager.sh
```

### Instalación Manual

1. **Instalar dependencias:**
   ```bash
   sudo apt update
   sudo apt install -y sshfs encfs python3
   ```

2. **Crear directorios:**
   ```bash
   mkdir -p $HOME/vpnadmin/VPN-encrypted
   mkdir -p $HOME/vpnadmin/VPN
   ```

3. **Obtener información del sistema:**
   ```bash
   id  # Anota tu UID y GID
   ```

4. **Configurar alias en shell:**
   
   Los alias se agregan automáticamente al archivo de configuración de tu shell (`.zshrc` o `.bashrc`).

---

## 🎯 Uso del Sistema

### Proceso Completo (Recomendado)

**Un solo comando para todo:**

```bash
vpn-full TU_USUARIO_SERVIDOR NOMBRE_CLIENTE
```

**Ejemplo:**
```bash
vpn-full felipe.gonzalez inn-saturno
```

Este comando:
1. Monta el directorio encriptado
2. Solicita la contraseña de descifrado
3. Crea las credenciales nuevas
4. Genera el paquete tar-file
5. Informa la ubicación del archivo final

### Proceso Paso a Paso

Si necesitas más control:

```bash
# 1. Verificar estado
vpn-status

# 2. Montar directorio encriptado
vpn-mount TU_USUARIO_SERVIDOR

# 3. Descifrar directorio
vpn-decrypt

# 4. Listar clientes existentes (opcional)
vpn-list

# 5. Crear credenciales nuevas
vpn-create NOMBRE_CLIENTE

# 6. Crear paquete para transferir
vpn-package NOMBRE_CLIENTE

# 7. Desmontar al finalizar
vpn-unmount
```

---

## 📚 Comandos Disponibles

| Comando | Descripción | Ejemplo |
|---------|-------------|----------|
| `vpn-help` | Mostrar ayuda completa | `vpn-help` |
| `vpn-status` | Ver estado de montaje | `vpn-status` |
| `vpn-mount [usuario]` | Montar directorio encriptado | `vpn-mount juan.perez` |
| `vpn-decrypt` | Descifrar directorio local | `vpn-decrypt` |
| `vpn-list` | Listar clientes VPN existentes | `vpn-list` |
| `vpn-create [nombre]` | Crear credenciales VPN | `vpn-create inn-marte` |
| `vpn-package [nombre]` | Crear tar-file para cliente | `vpn-package inn-marte` |
| `vpn-unmount` | Desmontar directorios | `vpn-unmount` |
| `vpn-full [usuario] [cliente]` | **Proceso completo** | `vpn-full user client` |
| `vpnmgr [comando]` | Acceso directo al script | `vpnmgr help` |

### Códigos de Color del Sistema

- 🔵 **Azul**: Información y procesos en curso
- 🟢 **Verde**: Operaciones exitosas
- 🟡 **Amarillo**: Advertencias e información importante
- 🔴 **Rojo**: Errores y problemas

---

## 💡 Ejemplos Prácticos

### Caso 1: Crear VPN Nueva (Proceso Completo)

```bash
# Crear VPN para cliente "inn-jupiter" con usuario "maria.lopez"
vpn-full maria.lopez inn-jupiter
```

**Salida esperada:**
```
=== Proceso completo para crear VPN ===
Usuario: maria.lopez
Cliente: inn-jupiter

Montando directorio encriptado...
✓ Directorio encriptado montado correctamente
Descifrando directorio...
✓ Directorio descifrado correctamente
Creando credenciales para: inn-jupiter
✓ Credenciales creadas exitosamente para inn-jupiter
Creando paquete tar para: inn-jupiter
✓ Paquete tar creado exitosamente
Archivo creado en: /home/felipe/vpnadmin/inn-jupiter.tar.gz

=== Proceso completado exitosamente ===
No olvides desmontar con: vpn-unmount
```

### Caso 2: Solo Crear Paquete para Cliente Existente

```bash
vpn-mount felipe.gonzalez
vpn-decrypt
vpn-package inn-saturno-existente
vpn-unmount
```

### Caso 3: Verificar Estado del Sistema

```bash
vpn-status
```

**Salida:**
```
Estado del sistema VPN:
✓ Directorio encriptado: MONTADO
✓ Directorio descifrado: MONTADO
```

---

## 🔧 Solución de Problemas

### Problemas Comunes

#### Error: "Directorio no montado"

**Problema:** Intentas descifrar sin montar primero.

**Solución:**
```bash
vpn-mount TU_USUARIO
vpn-decrypt
```

#### Error: "Cliente ya existe"

**Problema:** Ya existe un cliente con ese nombre.

**Solución:**
- Verifica clientes existentes: `vpn-list`
- Usa un nombre diferente
- O crea solo el paquete: `vpn-package nombre-existente`

#### Error: "No se puede conectar al servidor"

**Problema:** Problemas de conectividad SSH.

**Solución:**
- Verifica conectividad: `ping intranet.innovex.cl`
- Prueba conexión SSH: `ssh tu.usuario@intranet.innovex.cl`
- Verifica credenciales SSH

#### Directorios No Se Desmontan

**Solución:**
```bash
# Forzar desmontaje
sudo umount -f $HOME/vpnadmin/VPN
sudo umount -f $HOME/vpnadmin/VPN-encrypted
```

### Verificar Instalación

```bash
# Verificar herramientas instaladas
which sshfs encfs python3 pandoc

# Verificar estructura de directorios
ls -la ~/vpnadmin/

# Verificar alias
alias | grep vpn

# Verificar script principal
~/vpnadmin/vpn-manager.sh help
```

---

## 🔨 Scripts Técnicos

### Estructura de Archivos

```
/home/felipe/vpnadmin/
├── vpn-manager.sh          # Script principal (8.1kb)
├── setup-vpn-manager.sh    # Script de instalación (2.6kb)
├── VPN/                    # Directorio para datos descifrados
├── VPN-encrypted/          # Directorio para montaje encriptado
└── [cliente].tar.gz        # Archivos generados
```

### vpn-manager.sh - Funcionalidades

**Funciones principales:**
- `mount_encrypted()` - Monta directorio remoto vía SSHFS
- `decrypt_directory()` - Descifra usando EncFS
- `create_credentials()` - Ejecuta script de creación de claves
- `create_package()` - Genera tar-file para transferencia
- `full_process()` - Automatiza todo el proceso

**Configuración automática:**
- Usuario ID y Group ID detectados automáticamente
- Servidor: `intranet.innovex.cl`
- Ruta remota: `/home/pablo/vpnadmin/VPN-encrypted`

### Alias Configurados Automáticamente

Se agregan al archivo de configuración del shell:

```bash
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
```

### Proceso de Despliegue en Cliente

1. **Transferir archivo tar:**
   ```bash
   scp ~/vpnadmin/cliente.tar.gz usuario@destino:
   ```

2. **En máquina destino:**
   ```bash
   # Extraer en directorio OpenVPN
   sudo tar -xzf cliente.tar.gz -C /etc/openvpn/
   # o
   sudo tar -xzf cliente.tar.gz -C /etc/openvpn/client/
   ```

3. **Configurar y probar conexión según instalación local**

---

## 📞 Contactos y Recursos

- **Contraseña de descifrado**: Pablo Santamarina (teléfono)
- **Servidor**: `intranet.innovex.cl`
- **Documentación técnica**: Este documento
- **Scripts**: `/home/felipe/vpnadmin/`

---

## 📋 Checklist de Verificación

**Antes de crear VPN:**
- [ ] Dependencias instaladas (`sshfs`, `encfs`, `python3`)
- [ ] Directorios creados (`~/vpnadmin/VPN*`)
- [ ] Alias configurados y funcionando
- [ ] Conectividad SSH al servidor
- [ ] Contraseña de descifrado disponible

**Proceso de creación:**
- [ ] Comando ejecutado: `vpn-full usuario cliente`
- [ ] Directorio montado correctamente
- [ ] Descifrado exitoso
- [ ] Credenciales creadas sin errores
- [ ] Paquete tar generado
- [ ] Directorios desmontados

**Después de crear VPN:**
- [ ] Archivo tar-file presente en `~/vpnadmin/`
- [ ] Transferencia a máquina destino planificada
- [ ] Configuración en cliente pendiente

---

*Este documento fue generado automáticamente por el sistema VPN Manager v1.0*
