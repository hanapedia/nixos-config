#!/usr/bin/env bash

set -euo pipefail

# Run tailscale up and capture output
echo "[INFO] Running 'tailscale up'..."
output=$(tailscale up "$@" 2>&1 | tee /tmp/tailscale-up.log)

# Extract login URL
login_url=$(echo "$output" | grep -oE 'https://login.tailscale.com/a/[a-zA-Z0-9]+')

if [[ -n "$login_url" ]]; then
  echo
  echo "[INFO] Tailscale login URL detected:"
  echo "  $login_url"

  # Try to show QR code
  if command -v qrencode &> /dev/null; then
    echo
    echo "[INFO] Displaying QR code below (scan with phone browser):"
    echo
    qrencode -t ansiutf8 --margin=1 "$login_url" || {
      echo "[WARN] ansiutf8 mode failed, retrying with ANSI mode..."
      qrencode -t ANSI --margin=1 "$login_url"
    }
  else
    echo
    echo "[WARN] 'qrencode' is not installed."
    echo "[INFO] You can install it with:"
    echo "  nix-shell -p qrencode"
  fi
else
  echo "[ERROR] No Tailscale login URL found in output."
  exit 1
fi
