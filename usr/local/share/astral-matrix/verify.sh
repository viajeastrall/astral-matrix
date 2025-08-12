#!/usr/bin/env bash
# astral-verify — Audita BIOS/OC/ZRAM/BBR/PCIe/ReBAR de forma no intrusiva
set -Euo pipefail
. /usr/local/share/astral-matrix/utils.sh

rc=0

print_section "CPU/RAM (DOCP / SVM)"
if have dmidecode; then
  spd=$(sudo dmidecode --type 17 | awk '/Configured Memory Speed/ {print $4; exit}')
  if [[ -n "${spd:-}" && "$spd" -ge 3000 ]]; then
    ok "DOCP/XMP activo (~${spd} MHz)"
  else
    bad "DOCP/XMP no detectado (Configured Memory Speed=${spd:-N/A})"; rc=1
  fi
else
  warn "dmidecode no disponible"; rc=1
fi

if lscpu | grep -qi svm; then
  ok "SVM Mode habilitado"
else
  bad "SVM Mode no detectado"; rc=1
fi

print_section "PBO / Curve Optimizer (limitado desde SO)"
if have ryzenadj; then
  if sudo ryzenadj -i 2>/dev/null | grep -qi pbo; then
    ok "Se detectan parámetros PBO vía ryzenadj"
  else
    warn "No se detectan parámetros PBO con ryzenadj (normal si no configuraste desde SO)"
  fi
else
  warn "ryzenadj no instalado"
fi

print_section "PCIe / Resizable BAR"
if have nvidia-smi; then
  nvidia-smi -q | awk '/Resizable BAR/{p=1} p&&/:/ {print} /==================/{p=0}' || true
  bus=$(nvidia_bus_id || true)
  if [[ -n "${bus:-}" ]] && have lspci; then
    lspci -s "$bus" -vv | grep -E "LnkSta|LnkCap" || true
    ok "PCIe info mostrada (bus $bus)"
  else
    warn "No se pudo leer LnkSta/LnkCap (falta lspci o bus)"
  fi
else
  warn "nvidia-smi no disponible"
fi

print_section "Almacenamiento / TRIM / NVMe"
if systemctl is-enabled fstrim.timer >/dev/null 2>&1; then
  ok "fstrim.timer habilitado"
else
  bad "fstrim.timer deshabilitado"; rc=1
fi
for sch in /sys/block/nvme*/queue/scheduler; do
  [[ -f "$sch" ]] && printf "ℹ️  %s → %s\n" "$sch" "$(cat "$sch")"
done

print_section "Red (BBR / fq)"
cc=$(sysctl -n net.ipv4.tcp_congestion_control 2>/dev/null || true)
qd=$(sysctl -n net.core.default_qdisc 2>/dev/null || true)
[[ "$cc" == "bbr" ]] && ok "TCP congestion control = bbr" || { bad "TCP congestion control = ${cc:-N/A} (esperado: bbr)"; rc=1; }
[[ "$qd" == "fq"  ]] && ok "default_qdisc = fq"          || { bad "default_qdisc = ${qd:-N/A} (esperado: fq)"; rc=1; }

print_section "Memoria (ZRAM)"
if compgen -G "/sys/block/zram*/disksize" >/dev/null; then
  grep -H . /sys/block/zram*/{disksize,comp_algorithm} 2>/dev/null || true
  ok "ZRAM presente"
else
  warn "ZRAM no detectado (opcional)"
fi

printf "\nResumen: "
case $rc in
  0) printf "✅ OK\n";;
  1) printf "⚠️  Revisar advertencias\n";;
  *) printf "❌ Fallos críticos\n";;
esac
exit "$rc"
