#!/bin/bash
set -e

# Boje
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}==============================${NC}"
echo -e "${YELLOW}  Karcher IFSF - Installer    ${NC}"
echo -e "${YELLOW}==============================${NC}"

# Provera OS
if ! grep -q "Ubuntu 24" /etc/os-release 2>/dev/null; then
  echo -e "${RED}✗ Greška: Ova skripta zahteva Ubuntu 24. Instalacija prekinuta.${NC}"
  exit 1
fi
echo -e "${GREEN}✓ Ubuntu 24 detektovan${NC}"

# Provera da li je wget dostupan
if ! command -v wget &>/dev/null; then
  echo "=> Instalacija wget..."
  apt-get install -y wget
fi

BASE_URL="https://raw.githubusercontent.com/dusanstankovic-r2w/karcher_IFSF/main/U24_Noble"

FILES=(
  "edge-log-uploader_1.0.0_all.deb"
  "pos-bridge_1.0.2+noble_amd64.deb"
)

# Preuzimanje
echo -e "\n${YELLOW}=> Preuzimanje fajlova...${NC}"
for FILE in "${FILES[@]}"; do
  wget -q --show-progress "${BASE_URL}/${FILE}" -O "/tmp/${FILE}"
  if [ ! -f "/tmp/${FILE}" ]; then
    echo -e "${RED}✗ Greška: Nije moguce preuzeti ${FILE}${NC}"
    exit 1
  fi
  echo -e "${GREEN}✓ Preuzet: ${FILE}${NC}"
done

# Instalacija
echo -e "\n${YELLOW}=> Instalacija...${NC}"
for FILE in "${FILES[@]}"; do
  if dpkg -i "/tmp/${FILE}"; then
    echo -e "${GREEN}✓ Instaliran: ${FILE}${NC}"
  else
    echo -e "${RED}✗ Greška pri instalaciji: ${FILE}${NC}"
    exit 1
  fi
done

# Pokretanje servisa
echo -e "\n${YELLOW}=> Pokretanje servisa...${NC}"
systemctl enable pos-bridge
systemctl start pos-bridge
echo -e "${GREEN}✓ pos-bridge servis pokrenut${NC}"

# Provera instalacije
echo -e "\n${YELLOW}=> Provera instalacije...${NC}"
dpkg -l | grep -E "edge-log-uploader|pos-bridge" | while read -r line; do
  echo -e "${GREEN}✓ $(echo $line | awk '{print $2, $3}')${NC}"
done

# Ciscenje
rm -f /tmp/edge-log-uploader_1.0.0_all.deb /tmp/pos-bridge_1.0.2+noble_amd64.deb

echo -e "\n${GREEN}✅ Instalacija kompletna!${NC}"
