#!/bin/sh

# Variables
APP_DIR=${HOME}/.local/bin
APP_DATA_DIR=${HOME}/.local/share/tbcselect
APP_CONF_DIR=${HOME}/.config/tbcselect
DESKTOP_DIR=${HOME}/Desktop

# Generate desktop launcher
cat << LAUNCHER > ${PWD}/TBCSelect.desktop
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon=${APP_DATA_DIR}/tbcselect.svg
Icon[en_GB]=${APP_DATA_DIR}/tbcselect.svg
Name[en_GB]=TBCSelect
Exec=${APP_DIR}/tbcselect.sh
Name=TBCSelect
GenericName[en_GB]=TBCSelect
Comment[en_GB]=TBCSelect let you select exit countries for your Tor Browser
LAUNCHER

# installation
install -m 755 ${PWD}/tbcselect.sh ${APP_DIR}
install -m 755 -d ${APP_DATA_DIR}
install -m 664 ${PWD}/countries.list ${APP_DATA_DIR}
install -m 664 ${PWD}/tbcselect.svg ${APP_DATA_DIR}
install -m 755 -d ${APP_CONF_DIR}
install -m 755 ${PWD}/TBCSelect.desktop ${DESKTOP_DIR}

echo "TBCSelect has been installed."