# VPN Manager

Gestor automatizado para la creación y administración de clientes **OpenVPN**.  
Simplifica tareas como el montaje de directorios cifrados, generación de credenciales y empaquetado de configuraciones en un solo comando.

---

## 🚀 Características principales
- Crear clientes VPN con un solo comando (`vpn-full usuario cliente`).
- Montaje y descifrado automático de directorios (`sshfs` + `encfs`).
- Generación de credenciales y empaquetado en `.tar.gz`.
- Alias preconfigurados para las tareas más comunes:
  - `vpn-mount`, `vpn-umount`, `vpn-create`, `vpn-list`, etc.
- Guía de resolución de problemas incluida.

---

## 📦 Instalación rápida
Clona el repositorio y ejecuta el instalador:

```bash
git clone https://github.com/felipooon/vpn-manager.git
cd vpn-manager
chmod +x setup.sh
./setup.sh
```

Esto configurará los alias en tu shell y dejará el sistema listo para usar.

---

## 🛠️ Uso básico

Ejemplo de creación de cliente:

```bash
vpn-full usuario cliente
```

Listar clientes existentes:

```bash
vpn-list
```

Montar directorio cifrado:

```bash
vpn-mount
```

---

## 📖 Documentación completa
Para más detalles (paso a paso, troubleshooting, dependencias y explicación técnica), consulta:  

👉 [VPN_Documentation.md](./VPN_Documentation.md)

---

## 📜 Licencia
Este proyecto se distribuye bajo la licencia MIT.
