#!/bin/bash
set -e

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
# Auto-trigger build Tue Sep 23 20:02:58 BST 2025
