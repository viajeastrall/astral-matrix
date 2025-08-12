# Astral-Matrix — Optimización AMD Ryzen para Linux

## 📦 Instalación

### Opción 1: Desde el paquete .deb
```bash
# Construir el paquete
make build

# Instalar
sudo make install
```

### Opción 2: Instalación manual
```bash
# Instalar dependencias
sudo apt install bash coreutils systemd dmidecode pciutils procps grep gawk

# Recomendadas
sudo apt install linux-tools-generic system76-power nvme-cli stress-ng nvidia-utils

# Construir e instalar
dpkg-deb --build astral-matrix_2.2.0
sudo apt install ./astral-matrix_2.2.0.deb
```

## 🔹 Comandos principales

### Verificación del sistema
```bash
astral-verify         # Verifica estado de BIOS/OC (✅ / ⚠️ / ❌)
```

### Optimización de rendimiento
```bash
astral-perf           # Aplica perfil de rendimiento seguro para AMD
```

### Reportes de salud
```bash
astral-report         # Muestra snapshot de salud del sistema
```

## 🔹 Verificar estado de servicio semanal

```bash
# Estado del timer
systemctl status astral-weekly-report.timer

# Ver logs del servicio
journalctl -u astral-weekly-report.service -b

# Verificar que está habilitado
systemctl is-enabled astral-weekly-report.timer
```

## 🛠 Requisitos del sistema

### Dependencias obligatorias:
- `bash` - Shell de comandos
- `coreutils` - Utilidades básicas del sistema
- `systemd` - Sistema de servicios
- `dmidecode` - Información de hardware
- `pciutils` - Información de dispositivos PCI
- `procps` - Información de procesos
- `grep`, `gawk` - Procesamiento de texto

### Dependencias recomendadas:
- `linux-tools-generic` o `cpupower` - Control de CPU
- `system76-power` - Gestión de energía (Pop!_OS)
- `nvme-cli` - Información de dispositivos NVMe
- `stress-ng` - Pruebas de estrés
- `ryzenadj` - Ajustes avanzados de AMD Ryzen
- `nvidia-utils` - Utilidades NVIDIA

## 🎯 Uso típico

### 1. Verificar estado inicial
```bash
astral-verify
```

### 2. Aplicar optimizaciones
```bash
astral-perf
```

### 3. Verificar resultados
```bash
astral-report
```

### 4. Monitoreo continuo
```bash
# Verificar que el timer semanal está activo
systemctl status astral-weekly-report.timer

# Ver reportes semanales
journalctl -u astral-weekly-report.service --since "1 week ago"
```

## 🔧 Configuración avanzada

### Personalizar reportes semanales
```bash
# Editar el servicio
sudo systemctl edit astral-weekly-report.service

# Cambiar frecuencia del timer
sudo systemctl edit astral-weekly-report.timer
```

### Verificar instalación
```bash
# Verificar que los comandos están disponibles
which astral-verify astral-perf astral-report

# Verificar permisos
ls -la /usr/local/bin/astral-*
ls -la /usr/local/share/astral-matrix/

# Verificar servicios
systemctl list-units --type=timer | grep astral
```

## 🚨 Solución de problemas

### Si `astral-verify` falla:
```bash
# Verificar dependencias
dpkg -l | grep -E "(dmidecode|pciutils)"

# Instalar dependencias faltantes
sudo apt install dmidecode pciutils
```

### Si `astral-perf` no funciona:
```bash
# Verificar permisos
ls -la /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Verificar si cpupower está disponible
which cpupower
```

### Si los servicios no se inician:
```bash
# Recargar systemd
sudo systemctl daemon-reload

# Habilitar manualmente
sudo systemctl enable --now astral-weekly-report.timer
```

## 📊 Información del paquete

- **Versión**: 2.2.0
- **Arquitectura**: all (compatible con todas las arquitecturas)
- **Sección**: utils
- **Mantenedor**: Arvizu
- **Licencia**: GPL-3.0+

## 🧑‍💻 Autor

**Arvizu** — Proyecto Astral Matrix

## 📝 Licencia

Este proyecto está bajo la Licencia GPL-3.0. Ver el archivo LICENSE para más detalles.

---

**¡Tu sistema AMD Ryzen está listo para rendimiento máximo! 🚀**
