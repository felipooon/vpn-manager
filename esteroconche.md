# Procedimiento de Control de Flowpressors – Área de Inyección (Poseidón)

Este documento describe el uso de los scripts desarrollados para la gestión de **flowpressors** en centros de inyección.  
Dependiendo de la infraestructura y la situación operativa, se activan distintos scripts mediante `crontab`.

---

## 🎯 Objetivo

Garantizar la continuidad del suministro a las jaulas mediante la correcta configuración y selección de scripts que administran el flujo de uno o dos **flowpressors**, según la necesidad.

---

## 📂 Scripts disponibles

### 1. Centros de un solo módulo (caso más común)

- **`esteroconche.py`**  
  - Configura que todas las jaulas reciban flujo desde un único flowpressor (el principal).  
  - Se utiliza cuando **solo se requiere un flowpressor activo**.  

- **`two_flowpressor.py`**  
  - Divide el flujo entre **dos flowpressors**, cada uno operando al 50% de capacidad.  
  - Se utiliza para **balancear carga** o cuando el flujo de un solo equipo no es suficiente.  

---

### 2. Centros con dos módulos (caso eventual)

- **`esteroconche1.py`**  
  - Configura que el **primer flowpressor** abastezca únicamente al **módulo 1**.  

- **`esteroconche2.py`**  
  - Configura que el **segundo flowpressor** abastezca únicamente al **módulo 2**.  

---

## ⚙️ Modo de uso

1. Los scripts están configurados en **`crontab`**.  
2. Según la situación operacional:  
   - Se **comenta** el script que no corresponde.  
   - Se **activa** (descomenta) el script que debe estar en ejecución.  
3. Solo un set de scripts debe estar activo a la vez (dependiendo de si es un centro de un módulo o dos módulos).  

---

## 🧑‍🤝‍🧑 Roles y responsabilidades

- **Operadores de inyección**: Ejecutan y validan el script correcto según la situación del centro.  
- **Soporte técnico**: Configura `crontab` y realiza mantenimiento/corrección de scripts en caso de falla.  
- **Supervisión Poseidón**: Valida que la configuración de flujos cumpla con los parámetros de operación establecidos.  

---

## 📞 Soporte

En caso de dudas o incidentes:  
- **Equipo de inyección**: [correo interno o contacto]  
- **Soporte Poseidón**: [correo de soporte]  

---
