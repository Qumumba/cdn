#!/bin/bash

# Run using: sudo apt install -y curl && curl -L https://cdn.tars.sh/setup | bash

set -euo pipefail

GREY='\033[1;30m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
NO_COLOR='\033[0m'
NO_COLOR_BOLD='\033[1m'

TARS_SUCCESS="[${GREEN}TARS${NO_COLOR}]"
TARS_INFO="[${MAGENTA}TARS${NO_COLOR}]"
TARS_WARN="[${YELLOW}TARS${NO_COLOR}]"
TARS_ERROR="[${RED}TARS${NO_COLOR}]"
SEPARATOR="${GREY}--------------------------------------------${NO_COLOR}"

section() {
	echo ""
	echo -e "${SEPARATOR}"
	echo -e "${TARS_INFO} ${NO_COLOR_BOLD}${1}${NO_COLOR}"
	echo -e "${SEPARATOR}"
	echo ""
}

note() { echo -e "${TARS_INFO} ${1}"; }
warn() { echo -e "${TARS_WARN} ${1}"; }

FAILED=()
record_failure() {
	warn "Failed to install ${NO_COLOR_BOLD}${1}${NO_COLOR}, continuing."
	FAILED+=("${1}")
}

export DEBIAN_FRONTEND=noninteractive
APT_GET=(sudo apt-get -q -o Dpkg::Progress-Fancy=0)

apt_install() {
	"${APT_GET[@]}" install -y "$@" </dev/null || record_failure "$*"
}

DOCKER_CONFLICTS=(docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc)

USER_NAME="${USER:-$(id -un)}"
CODENAME="$(. /etc/os-release && echo "${VERSION_CODENAME:-}")"

if [ -z "${CODENAME}" ]; then
	echo -e "${TARS_ERROR} Could not read VERSION_CODENAME from /etc/os-release. Aborting."
	exit 1
fi

sudo -v
while true; do
	sudo -n true 2>/dev/null || exit
	sleep 50
	kill -0 "$$" 2>/dev/null || exit
done &
SUDO_KEEPALIVE_PID=$!
trap 'kill "${SUDO_KEEPALIVE_PID}" 2>/dev/null || true' EXIT

section "Configuring package sources"

sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc &
sudo curl -fsSL https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc -o /etc/apt/keyrings/debian.griffo.io.asc &
wait

sudo chmod a+r /etc/apt/keyrings/docker.asc /etc/apt/keyrings/debian.griffo.io.asc

sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: ${CODENAME}
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo tee /etc/apt/sources.list.d/debian.griffo.io.sources >/dev/null <<EOF
Types: deb
URIs: https://debian.griffo.io/apt
Suites: ${CODENAME}
Components: main
Signed-By: /etc/apt/keyrings/debian.griffo.io.asc
EOF

sudo rm -f /etc/apt/sources.list.d/debian.griffo.io.list /etc/apt/trusted.gpg.d/debian.griffo.io.gpg

note "Docker and eza repositories configured for ${NO_COLOR_BOLD}${CODENAME}${NO_COLOR}"

section "Updating Linux Packages"

"${APT_GET[@]}" update </dev/null

section "Installing packages included in APT"

apt_install micro fastfetch git nodejs npm imagemagick

section "Installing NVM"

if [ -d "${HOME}/.nvm" ]; then
	note "Already installed, skipping."
else
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash || record_failure "NVM"
fi

section "Installing EZA"

apt_install eza

section "Installing dtop"

if command -v dtop >/dev/null 2>&1; then
	note "Already installed, skipping."
else
	curl --proto '=https' --tlsv1.2 -LsSf https://github.com/amir20/dtop/releases/latest/download/dtop-installer.sh | sh || record_failure "dtop"
fi

section "Installing WITR (Why Is This Running)"

if command -v witr >/dev/null 2>&1; then
	note "Already installed, skipping."
else
	curl -fsSL https://raw.githubusercontent.com/pranshuparmar/witr/main/install.sh | bash || record_failure "WITR"
fi

section "Installing Docker"

CONFLICTS_PRESENT=()
for pkg in "${DOCKER_CONFLICTS[@]}"; do
	if [ "$(dpkg-query -W -f='${db:Status-Status}' "${pkg}" 2>/dev/null || true)" = "installed" ]; then
		CONFLICTS_PRESENT+=("${pkg}")
	fi
done

if [ ${#CONFLICTS_PRESENT[@]} -gt 0 ]; then
	note "Removing conflicting packages: ${NO_COLOR_BOLD}${CONFLICTS_PRESENT[*]}${NO_COLOR}"
	"${APT_GET[@]}" remove -y "${CONFLICTS_PRESENT[@]}" </dev/null
fi

apt_install ca-certificates docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker "${USER_NAME}"

section "Cleaning Linux Packages"

"${APT_GET[@]}" autoremove -y </dev/null
"${APT_GET[@]}" clean </dev/null

echo ""
echo -e "${SEPARATOR}"
if [ ${#FAILED[@]} -gt 0 ]; then
	echo -e "${TARS_WARN} These failed to install: ${NO_COLOR_BOLD}${FAILED[*]}${NO_COLOR}"
fi
echo -e "${TARS_SUCCESS} Setup installed in ${NO_COLOR_BOLD}$((SECONDS / 60))m $((SECONDS % 60))s${NO_COLOR}. ${NO_COLOR_BOLD}Please restart.${NO_COLOR}"
echo -e "${SEPARATOR}"
echo ""