#!/bin/bash

# Run using: curl -L https://cdn.tars.sh/setup | bash

GREY='\033[1;30m'
GREEN='\033[0;32m'
MAGENTA='\033[0;35m'
NO_COLOR='\033[0m'
NO_COLOR_BOLD='\033[1m'

TARS_SUCCESS="[${GREEN}TARS${NO_COLOR}]"
TARS_INFO="[${MAGENTA}TARS${NO_COLOR}]"
SEPARATOR="${GREY}--------------------------------------------${NO_COLOR}"

# Update & Clean Linux Packages
echo ""
echo -e "${SEPARATOR}"
echo -e "${TARS_INFO} ${NO_COLOR_BOLD}Updating & Cleaning Linux Packages"
echo -e "${SEPARATOR}"
echo ""

sudo apt update
sudo apt autoremove -y
sudo apt clean

# Install packages included in APT
echo ""
echo -e "${SEPARATOR}"
echo -e "${TARS_INFO} Installing ${NO_COLOR_BOLD}packages included in APT${NO_COLOR}"
echo -e "${SEPARATOR}"
echo ""

sudo apt install -y micro fastfetch curl git nodejs npm imagemagick

# NVM
echo ""
echo -e "${SEPARATOR}"
echo -e "${TARS_INFO} Installing ${NO_COLOR_BOLD}NVM${NO_COLOR}"
echo -e "${SEPARATOR}"
echo ""

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

#EZA
echo ""
echo -e "${SEPARATOR}"
echo -e "${TARS_INFO} Installing ${NO_COLOR_BOLD}EZA${NO_COLOR}"
echo -e "${SEPARATOR}"
echo ""

curl -sS https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/debian.griffo.io.gpg
echo "deb https://debian.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/debian.griffo.io.list
sudo apt update
sudo apt install eza

# dtop
echo ""
echo -e "${SEPARATOR}"
echo -e "${TARS_INFO} Installing ${NO_COLOR_BOLD}dtop${NO_COLOR}"
echo -e "${SEPARATOR}"
echo ""
curl --proto '=https' --tlsv1.2 -LsSf https://github.com/amir20/dtop/releases/latest/download/dtop-installer.sh | sh

# WITR (Why Is This Running)
echo ""
echo -e "${SEPARATOR}"
echo -e "${TARS_INFO} Installing ${NO_COLOR_BOLD}WITR (Why Is This Running)${NO_COLOR}"
echo -e "${SEPARATOR}"
echo ""

curl -fsSL https://raw.githubusercontent.com/pranshuparmar/witr/main/install.sh | bash

# Docker
echo ""
echo -e "${SEPARATOR}"
echo -e "${TARS_INFO} Installing ${NO_COLOR_BOLD}Docker${NO_COLOR}"
echo -e "${SEPARATOR}"
echo ""

sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-doc podman-docker containerd runc | cut -f1)
sudo apt update && sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER

# Complete
echo ""
echo -e "${SEPARATOR}"
echo -e "${TARS_SUCCESS} Setup Installed. ${NO_COLOR_BOLD}Please restart.${NO_COLOR}"
echo -e "${SEPARATOR}"
echo ""