# =============================================================================
# ASTRAL MATRIX PROJECT MAKEFILE
# Sistema de optimización para Machine Learning y alto rendimiento
# =============================================================================

# Variables
PROJECT_NAME = astral_matrix
SCRIPTS_DIR = scripts
LOGS_DIR = logs
DOCS_DIR = docs
CONFIGS_DIR = configs

# Scripts principales
OPTIMIZER = $(SCRIPTS_DIR)/astral_matrix_optimizer.sh
OPTIMIZER_V2 = $(SCRIPTS_DIR)/astral_matrix_optimizer_v2.sh
PERSISTENT = $(SCRIPTS_DIR)/astral_matrix_persistent.sh
MONITOR = $(SCRIPTS_DIR)/astral_matrix_monitor.sh

# Colores para output
CYAN = \033[0;36m
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m

# Target por defecto
.DEFAULT_GOAL := help

# =============================================================================
# TARGETS PRINCIPALES
# =============================================================================

.PHONY: help
help: ## Mostrar esta ayuda
	@echo -e "$(CYAN)╔══════════════════════════════════════════════════════════════╗$(NC)"
	@echo -e "$(CYAN)║                    ASTRAL MATRIX PROJECT                    ║$(NC)"
	@echo -e "$(CYAN)║              Sistema de Optimización para ML v2.0           ║$(NC)"
	@echo -e "$(CYAN)╚══════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo -e "$(GREEN)Comandos disponibles:$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: setup
setup: ## Configurar el proyecto (crear directorios y permisos)
	@echo -e "$(CYAN)Configurando proyecto Astral Matrix...$(NC)"
	mkdir -p $(LOGS_DIR) $(DOCS_DIR) $(CONFIGS_DIR)
	chmod +x $(SCRIPTS_DIR)/*.sh
	@echo -e "$(GREEN)✓ Proyecto configurado$(NC)"

.PHONY: lint
lint: ## Verificar sintaxis de los scripts (requiere shellcheck)
	@echo -e "$(CYAN)Verificando sintaxis de scripts...$(NC)"
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck $(SCRIPTS_DIR)/*.sh; \
		echo -e "$(GREEN)✓ Linting completado$(NC)"; \
	else \
		echo -e "$(YELLOW)⚠ shellcheck no está instalado. Instalando...$(NC)"; \
		sudo apt update && sudo apt install -y shellcheck; \
		shellcheck $(SCRIPTS_DIR)/*.sh; \
		echo -e "$(GREEN)✓ Linting completado$(NC)"; \
	fi

.PHONY: test
test: ## Ejecutar tests básicos (requiere bats)
	@echo -e "$(CYAN)Ejecutando tests...$(NC)"
	@if command -v bats >/dev/null 2>&1; then \
		bats test/; \
	else \
		echo -e "$(YELLOW)⚠ bats no está instalado. Instalando...$(NC)"; \
		sudo apt update && sudo apt install -y bats; \
		bats test/; \
	fi

.PHONY: check
check: ## Verificar estado del sistema sin aplicar cambios
	@echo -e "$(CYAN)Verificando estado del sistema...$(NC)"
	sudo $(OPTIMIZER_V2) --check

.PHONY: dry-run
dry-run: ## Simular optimizaciones sin aplicarlas
	@echo -e "$(CYAN)Simulando optimizaciones...$(NC)"
	sudo $(OPTIMIZER_V2) --dry-run

.PHONY: optimize
optimize: ## Aplicar optimizaciones completas
	@echo -e "$(CYAN)Aplicando optimizaciones Astral Matrix...$(NC)"
	sudo $(OPTIMIZER_V2) --apply

.PHONY: reset
reset: ## Resetear configuraciones a valores por defecto
	@echo -e "$(CYAN)Reseteando configuraciones...$(NC)"
	sudo $(OPTIMIZER_V2) --reset

.PHONY: run
run: ## Comando rápido para aplicar optimizaciones (alias de optimize)
	@$(MAKE) optimize

.PHONY: final-check
final-check: ## Verificar estado con Final Touch
	@bash scripts/astral_final_touch.sh --check

.PHONY: final-apply
final-apply: ## Aplicar Final Touch (TRIM, BBR, ZRAM, limpieza)
	@bash scripts/astral_final_touch.sh --apply

.PHONY: report
report: ## Generar reporte de salud del sistema
	@bash scripts/astral_final_touch.sh --report

.PHONY: timer-enable
timer-enable: ## Habilitar reporte semanal automático
	@sudo cp systemd/astral-weekly-report.* /etc/systemd/system/ && sudo systemctl daemon-reload && sudo systemctl enable --now astral-weekly-report.timer && systemctl list-timers astral-weekly-report.timer

.PHONY: timer-disable
timer-disable: ## Deshabilitar reporte semanal automático
	@sudo systemctl disable --now astral-weekly-report.timer || true

.PHONY: persistent
persistent: ## Aplicar configuraciones persistentes
	@echo -e "$(CYAN)Aplicando configuraciones persistentes...$(NC)"
	sudo $(PERSISTENT)

.PHONY: monitor
monitor: ## Monitorear rendimiento del sistema
	@echo -e "$(CYAN)Monitoreando rendimiento...$(NC)"
	$(MONITOR)

.PHONY: reset
reset: ## Resetear configuraciones a valores por defecto
	@echo -e "$(CYAN)Reseteando configuraciones...$(NC)"
	sudo $(OPTIMIZER) --reset

.PHONY: logs
logs: ## Mostrar logs recientes
	@echo -e "$(CYAN)Mostrando logs recientes...$(NC)"
	@if [ -d "$(LOGS_DIR)" ]; then \
		ls -la $(LOGS_DIR)/ | head -10; \
		echo ""; \
		echo -e "$(GREEN)Último log:$(NC)"; \
		ls -t $(LOGS_DIR)/*.log 2>/dev/null | head -1 | xargs tail -20 2>/dev/null || echo "No hay logs disponibles"; \
	else \
		echo -e "$(YELLOW)Directorio de logs no existe$(NC)"; \
	fi

.PHONY: clean
clean: ## Limpiar archivos temporales y logs antiguos
	@echo -e "$(CYAN)Limpiando archivos temporales...$(NC)"
	find . -name "*.tmp" -delete
	find . -name "*.log" -mtime +7 -delete 2>/dev/null || true
	@echo -e "$(GREEN)✓ Limpieza completada$(NC)"

.PHONY: install-deps
install-deps: ## Instalar dependencias necesarias
	@echo -e "$(CYAN)Instalando dependencias...$(NC)"
	sudo apt update
	sudo apt install -y \
		shellcheck \
		bats \
		bc \
		htop \
		iotop \
		nvme-cli \
		nvidia-settings \
		zram-tools
	@echo -e "$(GREEN)✓ Dependencias instaladas$(NC)"

.PHONY: status
status: ## Mostrar estado actual del sistema
	@echo -e "$(CYAN)Estado del sistema:$(NC)"
	@echo -e "$(GREEN)CPU Governor:$(NC) $(shell cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo 'N/A')"
	@echo -e "$(GREEN)vm.swappiness:$(NC) $(shell cat /proc/sys/vm/swappiness 2>/dev/null || echo 'N/A')"
	@echo -e "$(GREEN)Hugepages:$(NC) $(shell cat /proc/sys/vm/nr_hugepages 2>/dev/null || echo 'N/A')"
	@echo -e "$(GREEN)ZRAM:$(NC) $(shell swapon --show | grep -q zram && echo 'Activo' || echo 'Inactivo')"
	@if command -v nvidia-smi >/dev/null 2>&1; then \
		echo -e "$(GREEN)GPU:$(NC) $(shell nvidia-smi --query-gpu=name --format=csv,noheader,nounits | head -1)"; \
	else \
		echo -e "$(GREEN)GPU:$(NC) No disponible"; \
	fi

.PHONY: benchmark
benchmark: ## Ejecutar benchmarks rápidos
	@echo -e "$(CYAN)Ejecutando benchmarks...$(NC)"
	@echo -e "$(GREEN)CPU Benchmark (cálculo de π):$(NC)"
	@time echo "scale=1000; 4*a(1)" | bc -l 2>/dev/null | tail -1 || echo "bc no disponible"
	@echo -e "$(GREEN)Memoria Benchmark:$(NC)"
	@dd if=/dev/zero of=/tmp/benchmark bs=1M count=100 2>/dev/null | tail -1 || echo "No se pudo ejecutar"
	@rm -f /tmp/benchmark

.PHONY: backup
backup: ## Crear backup de configuraciones actuales
	@echo -e "$(CYAN)Creando backup de configuraciones...$(NC)"
	@mkdir -p $(CONFIGS_DIR)/backup_$(shell date +%Y%m%d_%H%M%S)
	@cp /etc/sysctl.conf $(CONFIGS_DIR)/backup_$(shell date +%Y%m%d_%H%M%S)/ 2>/dev/null || true
	@cp /etc/security/limits.conf $(CONFIGS_DIR)/backup_$(shell date +%Y%m%d_%H%M%S)/ 2>/dev/null || true
	@echo -e "$(GREEN)✓ Backup creado$(NC)"

.PHONY: restore
restore: ## Restaurar configuración desde backup
	@echo -e "$(CYAN)Backups disponibles:$(NC)"
	@ls -la $(CONFIGS_DIR)/backup_* 2>/dev/null || echo "No hay backups disponibles"
	@echo -e "$(YELLOW)Para restaurar: make restore BACKUP=nombre_del_backup$(NC)"

# =============================================================================
# TARGETS DE DESARROLLO
# =============================================================================

.PHONY: dev-setup
dev-setup: ## Configurar entorno de desarrollo
	@echo -e "$(CYAN)Configurando entorno de desarrollo...$(NC)"
	mkdir -p test
	@if [ ! -f test/astral_matrix_test.bats ]; then \
		echo "#!/usr/bin/env bats" > test/astral_matrix_test.bats; \
		echo "" >> test/astral_matrix_test.bats; \
		echo "@test \"optimizer script exists\" {" >> test/astral_matrix_test.bats; \
		echo "  [ -f \"$(OPTIMIZER)\" ]" >> test/astral_matrix_test.bats; \
		echo "}" >> test/astral_matrix_test.bats; \
		echo "" >> test/astral_matrix_test.bats; \
		echo "@test \"optimizer script is executable\" {" >> test/astral_matrix_test.bats; \
		echo "  [ -x \"$(OPTIMIZER)\" ]" >> test/astral_matrix_test.bats; \
		echo "}" >> test/astral_matrix_test.bats; \
	fi
	chmod +x test/*.bats
	@echo -e "$(GREEN)✓ Entorno de desarrollo configurado$(NC)"

.PHONY: validate
validate: lint test ## Validar todo el proyecto
	@echo -e "$(GREEN)✓ Validación completada$(NC)"

# =============================================================================
# TARGETS DE DEPLOYMENT
# =============================================================================

.PHONY: install
install: setup install-deps ## Instalar el sistema completo
	@echo -e "$(CYAN)Instalando Astral Matrix Optimizer...$(NC)"
	sudo cp $(SCRIPTS_DIR)/*.sh /usr/local/bin/
	sudo chmod +x /usr/local/bin/astral_matrix_*.sh
	@echo -e "$(GREEN)✓ Astral Matrix Optimizer instalado$(NC)"

.PHONY: uninstall
uninstall: ## Desinstalar el sistema
	@echo -e "$(CYAN)Desinstalando Astral Matrix Optimizer...$(NC)"
	sudo rm -f /usr/local/bin/astral_matrix_*.sh
	@echo -e "$(GREEN)✓ Astral Matrix Optimizer desinstalado$(NC)"

# =============================================================================
# INFORMACIÓN DEL PROYECTO
# =============================================================================

.PHONY: info
info: ## Mostrar información del proyecto
	@echo -e "$(CYAN)╔══════════════════════════════════════════════════════════════╗$(NC)"
	@echo -e "$(CYAN)║                    ASTRAL MATRIX PROJECT                    ║$(NC)"
	@echo -e "$(CYAN)╚══════════════════════════════════════════════════════════════╝$(NC)"
	@echo -e "$(GREEN)Versión:$(NC) 2.0"
	@echo -e "$(GREEN)Autor:$(NC) AstralMatrix"
	@echo -e "$(GREEN)Descripción:$(NC) Sistema de optimización para Machine Learning"
	@echo -e "$(GREEN)Compatibilidad:$(NC) Debian/Ubuntu/Pop!_OS"
	@echo ""
	@echo -e "$(GREEN)Scripts disponibles:$(NC)"
	@ls -la $(SCRIPTS_DIR)/*.sh 2>/dev/null || echo "No hay scripts disponibles"
	@echo ""
	@echo -e "$(GREEN)Uso rápido:$(NC)"
	@echo "  make optimize    # Aplicar optimizaciones"
	@echo "  make monitor     # Monitorear rendimiento"
	@echo "  make status      # Ver estado actual"

PACKAGE=astral-matrix
VERSION=2.2.0
BUILD_DIR=$(PACKAGE)_$(VERSION)_all

all: build

build:
	@echo "🔧 Construyendo .deb..."
	rm -rf $(BUILD_DIR) || true
	mkdir -p $(BUILD_DIR)
	cp -r DEBIAN usr lib $(BUILD_DIR)/ 2>/dev/null || true
	dpkg-deb --build $(BUILD_DIR)
	@echo "👉 Salida: $(BUILD_DIR).deb"

install:
	@echo "📦 Instalando .deb..."
	sudo apt install ./$(BUILD_DIR).deb

clean:
	rm -rf $(BUILD_DIR) $(BUILD_DIR).deb

test:
	@echo "🧪 Probando scripts..."
	./usr/local/share/astral-matrix/verify.sh || true
	./usr/local/share/astral-matrix/report.sh

package: clean build
	@echo "📦 Paquete $(BUILD_DIR).deb creado"

release: package
	@echo "🚀 Release $(VERSION) lista"
	@echo "📁 Archivo: $(BUILD_DIR).deb"
	@echo "📏 Tamaño: $(shell du -h $(BUILD_DIR).deb | cut -f1)"
