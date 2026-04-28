#!/bin/bash

###########################################################################
#
# AUTHOR:       (c) Irek Pelech <irekp@seniorlinuxadmin.co.uk>
# WWW:          https://seniorlinuxadmin.co.uk
# LICENSE:      GPL3 (https://www.gnu.org/licenses/gpl-3.0.html)
# REQUIRES:     bash, yad, sed, grep
# NAME:         TBCSelect
# DESCRIPTION:  TBCSelect let you select exit countries for your Tor Browser
# VERSION:      1.0.0 (2026)
#
############################################################################

# Variables
APP_DATA_DIR="${HOME}/.local/share/tbcselect"
APP_CONF_DIR="${HOME}/.config/tbcselect"
COUNTRIES_FILE="${APP_DATA_DIR}/countries.list"
CONFIG_FILE="${APP_CONF_DIR}/tbcselect.conf"
VERSION="1.0.0"
PNAME="TBCSelect ver. ${VERSION}"

# Functions
function remove_country() {
    sed -i '/ExitNodes/d;/StrictNodes 1/d' ${TORRC_LOCATION}
}

function get_installation_dir() {
    # Select Tor Browser installation directory
    TB_INST_DIR=$(yad --title="${PNAME}" --text="Select Tor Browser installation directory:" --button="Cancel!gtk-cancel":1 --button="Save!gtk-save":0 --file directory)
    EXIT_CODE=$?

    # If exit code 1 (cancel button) or 252 (window close) exit TBCSelect
    if [[ ${EXIT_CODE} -eq 1 ]] || [[ ${EXIT_CODE} -eq 252 ]] ; then    
        exit 0
    fi      

    echo "TB_INST_DIR=${TB_INST_DIR}" > ${CONFIG_FILE}      
}

function tbcselect_about() {
    yad --about \
        --image=${HOME}/.local/share/tbcselect/tbcselect.svg \
        --window-icon=gtk-about \
        --license="GPL3" \
        --comments="TBCSelect let you select exit countries for your Tor Browser" \
        --copyright="Copyright (c) 2026 Irek Pelech" \
        --pversion="1.0.0" \
        --pname="TBCSelect" \
        --website="https://seniorlinuxadmin.co.uk" \
        --button="Close!gtk-close":1
}

export -f tbcselect_about

### MAIN ###

# Check if yad is installed
if ! command -v yad &> /dev/null; then
    echo "Yad could not be found. Please install Yad"
    exit 1
fi

# Check if file with countries exist
if ! [ -f ${COUNTRIES_FILE} ]; then
    yad --title="${PNAME}" --button="Exit!gtk-exit:0" --text-align=center --text="${COUNTRIES_FILE} does not exist. Please check TBCSelect installation."
    exit 1
fi

# Check if configuration file exist
if [ -f ${CONFIG_FILE} ]; then
    . ${CONFIG_FILE}
    if [[ -z ${TB_INST_DIR} ]]; then
        get_installation_dir
    fi
else
    get_installation_dir
fi

TORRC_LOCATION="${TB_INST_DIR}/Browser/TorBrowser/Data/Tor/torrc"


# Check if torrc file exist
if ! [ -f ${TORRC_LOCATION} ]; then
    yad --title="${PNAME}" --button="Exit!gtk-exit:0" --text-align=center --text="File ${TORRC_LOCATION} does not exist."
    exit 1
fi

# Check currently selected countries if any
NODE_COUNTRY_CODES=$(grep "^ExitNodes" ${TORRC_LOCATION}|sed 's/ExitNodes //')

if ! [[ -z ${NODE_COUNTRY_CODES} ]]; then
    for i in ${NODE_COUNTRY_CODES//,/ }; do
        SEL_COUNTRIES+="$(grep -B1 $i ${COUNTRIES_FILE}|grep -v $i)\n"
    done

    yad --title="${PNAME}" --text="Currently selected countries:" --no-headers --button="Cancel!gtk-cancel":1 --button="OK!gtk-ok":0 --list --height=300 --width=350 --no-selection --column=Country <<< $(echo -e ${SEL_COUNTRIES})
    EXIT_CODE=$?
    if [[ ${EXIT_CODE} -eq 1 ]] || [[ ${EXIT_CODE} -eq 252 ]]; then
        exit 0
    fi
fi

# Select exit countries for Tor Browser 
NODE_COUNTRY_CODES=$(yad --title="${PNAME}" --text="Select Tor nodes exit countries:" --no-headers --button="Cancel!gtk-cancel":1 --button="OK!gtk-ok":0 --button="Remove!gtk-remove":2  --list --multiple --height=300 --width=350 --separator=" " --print-column=2 --column=Country --column=CountryCode:HD < ${COUNTRIES_FILE})
EXIT_CODE=$?

# If exit code 1 (cancel button) or 252 (window close) exit TBCSelect
if [[ ${EXIT_CODE} -eq 1 ]] || [[ ${EXIT_CODE} -eq 252 ]]; then
    exit 0
fi

# If country code(s) not selected or remove button has been pressed, remove existing countries setup for torrc file
if [[ -z ${NODE_COUNTRY_CODES} ]] && [[ ${EXIT_CODE} -eq 2 ]]; then
    remove_country
else
    remove_country
    echo -n "ExitNodes " >> ${TORRC_LOCATION}
    for CC in ${NODE_COUNTRY_CODES}; do
        echo -n "$CC," >> ${TORRC_LOCATION}       
    done
    echo -e "\nStrictNodes 1" >> ${TORRC_LOCATION}
fi

yad --title="${PNAME}" --height=120 --width=350 --button="About!gtk-about":"bash -c tbcselect_about" --button="OK!gtk-ok:0" --text-align=center --text="\n\nChanges has been applied."