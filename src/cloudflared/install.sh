#!/bin/bash
set -e

# Logging mechanism for debugging
LOG_FILE="/tmp/cloudflared-install.log"
log_debug() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [DEBUG] $*" >> "$LOG_FILE"
}

# Initialize logging
log_debug "=== CLOUDFLARED INSTALL STARTED ==="
log_debug "Script path: $0"
log_debug "PWD: $(pwd)"
log_debug "Environment: USER=$USER HOME=$HOME"

# Install Cloudflared with architecture detection
if ! command -v cloudflared &>/dev/null; then
  if [ "$(uname -m)" = "x86_64" ]; then
    ARCH=amd64
  else
    ARCH=arm64
  fi
  wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${ARCH}.deb
  sudo dpkg -i cloudflared-linux-${ARCH}.deb
  rm cloudflared-linux-${ARCH}.deb
fi

# Configure systemd service if available
if [ -d /run/systemd/system ] && [ -x /bin/systemctl ]; then
  if [ -f /etc/static/configs/system/cloudflared.service ]; then
    sudo cp /etc/static/configs/system/cloudflared.service /etc/systemd/system/cloudflared.service
    sudo systemctl enable cloudflared || true
    sudo systemctl start cloudflared || true
  fi
fi

# Clean up
sudo apt-get clean

log_debug "=== CLOUDFLARED INSTALL COMPLETED ==="
# Auto-trigger build Tue Sep 23 20:02:58 BST 2025
