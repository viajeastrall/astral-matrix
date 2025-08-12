#!/usr/bin/env bash
# astral-report — snapshot corto de salud del sistema
set -Euo pipefail
. /usr/local/share/astral-matrix/utils.sh

print_section "CPU"
have lscpu && lscpu | sed -n '1,20p'
printf "Governor(s): %s\n" "$(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null | sort -u | tr '\n' ' ')"
[[ -e /sys/devices/system/cpu/cpufreq/boost ]] && printf "Boost: %s\n" "$(cat /sys/devices/system/cpu/cpufreq/boost 2>/dev/null)"

print_section "GPU"
if have nvidia-smi; then
  nvidia-smi --query-gpu=name,driver_version,temperature.gpu,power.draw --format=csv,noheader,nounits
fi

print_section "RAM"
free -h

print_section "Discos/NVMe"
lsblk -o NAME,ROTA,TYPE,SIZE,MOUNTPOINT
for sch in /sys/block/nvme*/queue/scheduler; do
  [[ -f "$sch" ]] && printf "Scheduler %s: %s\n" "$sch" "$(cat "$sch")"
done

print_section "Red"
sysctl -n net.ipv4.tcp_congestion_control 2>/dev/null | sed 's/^/TCP cc: /'
sysctl -n net.core.default_qdisc 2>/dev/null | sed 's/^/qdisc: /'

ok "Reporte listo."
