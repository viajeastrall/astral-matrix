#!/usr/bin/env bash
# astral-perf — Perfil de rendimiento seguro para AMD (no toca thermal trip ni intel_pstate)
set -Euo pipefail
. /usr/local/share/astral-matrix/utils.sh

apply_governor_performance(){
  if have cpupower; then
    sudo cpupower frequency-set -g performance || true
  else
    for g in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
      [[ -w "$g" ]] && echo performance | sudo tee "$g" >/dev/null
    done
  fi
}

enable_boost(){
  [[ -e /sys/devices/system/cpu/cpufreq/boost ]] && echo 1 | sudo tee /sys/devices/system/cpu/cpufreq/boost >/dev/null || true
}

maybe_disable_ppd(){
  systemctl is-enabled power-profiles-daemon >/dev/null 2>&1 && sudo systemctl disable --now power-profiles-daemon || true
}

system76_perf(){
  have system76-power && system76-power profile performance || true
}

main(){
  print_section "Aplicando perfil AMD performance (seguro)"
  # watchdog: mantener activo (protección)
  [[ -w /proc/sys/kernel/nmi_watchdog ]] && echo 1 | sudo tee /proc/sys/kernel/nmi_watchdog >/dev/null || true
  apply_governor_performance
  enable_boost
  maybe_disable_ppd
  system76_perf
  ok "Perfil aplicado. Sugerencia: ejecuta 'astral-report' para ver estado."
}
main "$@"
