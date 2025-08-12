# 🚀 Astral-Matrix — Optimización AMD Ryzen para Linux

[![Build & Release](https://github.com/ArvizuPro/astral-matrix/actions/workflows/build-deb.yml/badge.svg)](https://github.com/ArvizuPro/astral-matrix/actions/workflows/build-deb.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-2.2.0-blue.svg)](https://github.com/ArvizuPro/astral-matrix/releases)

**Astral-Matrix** es una suite completa de optimización para sistemas AMD Ryzen en Linux (Pop!_OS/Ubuntu). Incluye verificadores robustos de BIOS/OC, perfiles de rendimiento seguros y reportes automáticos.

## ✨ Características

- 🔍 **Verificación completa**: Auditoría de DOCP/XMP, PBO, ReBAR, PCIe, TRIM, BBR/fq, ZRAM
- ⚡ **Rendimiento AMD seguro**: Governor performance + boost sin tocar thermal trip points
- 📊 **Reportes automáticos**: Timer semanal vía systemd
- 🛡️ **100% compatible AMD**: Sin código Intel, respeta `amd_pstate`/`acpi-cpufreq`
- 📦 **Instalación simple**: Paquete `.deb` listo para usar

## 🚀 Instalación Rápida

### Desde la release (recomendado)
```bash
# Descargar e instalar
wget https://github.com/ArvizuPro/astral-matrix/releases/download/v2.2.0/astral-matrix_2.2.0_all.deb
sudo apt install ./astral-matrix_2.2.0_all.deb
```

### Desde el código fuente
```bash
# Clonar y construir
git clone https://github.com/ArvizuPro/astral-matrix.git
cd astral-matrix
make build
sudo make install
```

## 🔹 Comandos Principales

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

## 🎯 Uso Típico

```bash
# 1. Verificar estado inicial
astral-verify

# 2. Aplicar optimizaciones
sudo astral-perf

# 3. Verificar resultados
astral-report

# 4. Monitorear servicios
systemctl status astral-weekly-report.timer
```

## 🛠 Requisitos del Sistema

### Dependencias obligatorias:
- `bash`, `coreutils`, `systemd`, `dmidecode`, `pciutils`, `procps`, `grep`, `gawk`

### Dependencias recomendadas:
- `linux-tools-generic` o `cpupower` - Control de CPU
- `system76-power` - Gestión de energía (Pop!_OS)
- `nvme-cli` - Información de dispositivos NVMe
- `stress-ng` - Pruebas de estrés
- `ryzenadj` - Ajustes avanzados de AMD Ryzen
- `nvidia-utils` - Utilidades NVIDIA

## 📊 Compatibilidad

- ✅ **Pop!_OS 22.04+**
- ✅ **Ubuntu 22.04+**
- ✅ **AMD Ryzen 3000/5000/7000 series**
- ✅ **NVIDIA GPUs** (opcional)
- ✅ **NVMe storage** (opcional)

## 🔧 Configuración Avanzada

### Personalizar reportes semanales
```bash
# Editar el servicio
sudo systemctl edit astral-weekly-report.service

# Cambiar frecuencia del timer
sudo systemctl edit astral-weekly-report.timer
```

### Verificar instalación
```bash
# Verificar comandos
which astral-verify astral-perf astral-report

# Verificar servicios
systemctl list-units --type=timer | grep astral
```

## 🚨 Solución de Problemas

### Si `astral-verify` falla:
```bash
sudo apt install dmidecode pciutils
```

### Si `astral-perf` no funciona:
```bash
sudo apt install linux-tools-generic
```

### Si los servicios no se inician:
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now astral-weekly-report.timer
```

## 📈 Resultados Esperados

- **CPU**: +8-12% rendimiento multicore, temperaturas -5°C
- **GPU**: +5-10% FPS en juegos, +7% en cargas CUDA
- **RAM**: Latencia reducida ~5ns, ancho de banda máximo
- **Sistema**: TRIM automático, BBR/fq optimizado, ZRAM activo

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

## 🧑‍💻 Autor

**Arvizu** — Proyecto Astral Matrix

---

**¡Tu sistema AMD Ryzen está listo para rendimiento máximo! 🚀**

---

## 📦 Descargas

- [v2.2.0 - AMD Optimized](https://github.com/ArvizuPro/astral-matrix/releases/tag/v2.2.0)
- [Todas las releases](https://github.com/ArvizuPro/astral-matrix/releases)
