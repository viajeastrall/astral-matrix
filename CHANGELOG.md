# Changelog - Astral Matrix

## [2.2.0] - 2024-08-12

### 🚀 Novedades
- **100% optimizado para AMD Ryzen** (eliminado todo código Intel)
- **Nuevo verificador `astral-verify`** con auditoría completa de BIOS/OC
- **`astral-perf` seguro**: governor performance + boost + compatibilidad system76-power
- **Reportes semanales automáticos** vía systemd
- **Modularización**: utils.sh centraliza funciones comunes
- **Documentación clara** y empaquetado .deb listo para Pop!_OS / Ubuntu

### 🐞 Correcciones
- Se evita modificar **trip points** o desactivar **thermal throttling**
- Se corrigen comandos peligrosos o incompatibles con AMD
- Mejor manejo de ausencia de dependencias (no rompe el script)
- **`pci.bus_id` corregido** (sin espacios)
- **Modo estricto ajustado** (continúa con todas las verificaciones)
- **Detecciones defensivas** (manejo robusto de comandos faltantes)

### 🔧 Mejoras Técnicas
- **Verificador robusto**: ✅/⚠️/❌ con exit codes 0/1/2
- **Rendimiento AMD seguro**: respeta `amd_pstate`/`acpi-cpufreq`
- **Servicios systemd**: timer semanal automático
- **Wrappers ejecutables**: `astral-verify`, `astral-perf`, `astral-report`
- **Dependencias reales**: compatibles con Ubuntu/Pop!_OS

### 📦 Empaquetado
- **Estructura .deb profesional** con postinst/prerm
- **Makefile** para construcción e instalación automática
- **Permisos correctos** para todos los archivos
- **Integración systemd** completa

---

## [2.1.0] - 2024-08-12

### 🚀 Novedades
- Scripts de optimización básicos
- Configuración de rendimiento inicial
- Documentación básica

### 🐞 Problemas Conocidos
- Código Intel incompatibles con AMD
- Verificador no robusto
- Falta de modularización

---

## [2.0.0] - 2024-08-12

### 🚀 Novedades
- Versión inicial del proyecto
- Scripts básicos de verificación
- Configuración de overclocking

---

**Nota**: Este changelog sigue el formato [Keep a Changelog](https://keepachangelog.com/).
