#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
#
# root.vpn bootstrap — download (NO git required) and run the hardened installer.
#
#   curl -fsSL https://raw.githubusercontent.com/antidetect/root.vpn/main/install.sh | sudo bash
#
# Optional config via environment, e.g.:
#   curl -fsSL .../install.sh | sudo REALITY_DEST=dl.google.com AWG_SNI=www.cloudflare.com bash
#
# On a fresh image the underlying installer reboots once or twice to load a new
# kernel — just re-run the SAME command after each reboot; it resumes safely.

set -euo pipefail

REPO="${ROOTVPN_REPO:-antidetect/root.vpn}"
REF="${ROOTVPN_REF:-main}"
DIR="${ROOTVPN_DIR:-/opt/root.vpn}"

[ "$(id -u)" -eq 0 ] || { echo "root.vpn: must run as root — pipe into 'sudo bash'"; exit 1; }

need() { command -v "$1" >/dev/null 2>&1; }
if ! need curl || ! need tar; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y >/dev/null 2>&1 || true
    apt-get install -y curl tar ca-certificates >/dev/null 2>&1 || true
fi
need curl || { echo "root.vpn: curl is required"; exit 1; }
need tar  || { echo "root.vpn: tar is required";  exit 1; }

echo "root.vpn: downloading ${REPO}@${REF} (no git needed) ..."
mkdir -p "$DIR"
curl -fsSL "https://github.com/${REPO}/archive/refs/heads/${REF}.tar.gz" \
    | tar -xz -C "$DIR" --strip-components=1
cd "$DIR"

# Carry any config passed via the environment into defaults.conf. defaults.conf is
# sourced last by awg2, so appended values win — this makes the curl one-liner
# configurable without an editor.
for v in AWG_SNI AWG_TUNNEL AWG_MIMICRY AWG_PRESET AWG_FIRST_CLIENT \
         TCP_ENABLED TCP_PORT TCP_TRANSPORT REALITY_DEST REALITY_SERVERNAME \
         XRAY_VERSION XRAY_FP CDN_DOMAIN; do
    if [ -n "${!v+x}" ]; then printf '%s=%q\n' "$v" "${!v}" >> defaults.conf; fi
done

chmod +x awg2
echo "root.vpn: starting installer — if the server reboots, re-run the same command to resume."
exec ./awg2 "$@"
