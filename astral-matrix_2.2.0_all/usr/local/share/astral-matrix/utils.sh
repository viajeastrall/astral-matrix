#!/usr/bin/env bash
set -Euo pipefail

ok()   { printf "✅ %s\n" "$*"; }
warn() { printf "⚠️  %s\n" "$*\n" >&2; }
bad()  { printf "❌ %s\n" "$*\n" >&2; }

have() { command -v "$1" >/dev/null 2>&1; }

print_section(){ printf "\n——— %s ———\n" "$*"; }

# seguro: escribe si es posible
writte(){
  local path="$1" val="$2"
  [[ -w "$path" ]] || { warn "No writable: $path"; return 1; }
  echo "$val" | sudo tee "$path" >/dev/null
}

# obtiene bus pcie GPU NVIDIA (si hay)
nvidia_bus_id(){
  have nvidia-smi || return 1
  nvidia-smi --query-gpu=pci.bus_id --format=csv,noheader | sed 's/^0000://;q'
}
