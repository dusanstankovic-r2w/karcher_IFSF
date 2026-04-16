#!/bin/bash
set -e

BASE_URL="https://raw.githubusercontent.com/dusanstankovic-r2w/karcher_IFSF/main/U24_Noble"

echo "==> Preuzimanje fajlova..."
wget -q --show-progress "${BASE_URL}/edge-log-uploader_1.0.0_all.deb" -O /tmp/edge-log-uploader.deb
wget -q --show-progress "${BASE_URL}/pos-bridge_1.0.2+noble_amd64.deb" -O /tmp/pos-bridge.deb

echo "==> Instalacija..."
dpkg -i /tmp/edge-log-uploader.deb
dpkg -i /tmp/pos-bridge.deb

echo "==> Ciscenje..."
rm /tmp/edge-log-uploader.deb /tmp/pos-bridge.deb

echo "✅ Sve instalirano uspesno!"
