#!/usr/bin/env bash

# From: https://gist.github.com/3bc5b5a397a9491a61787143b098da85#file-changejdk-bash

JDKS_DIR="/Library/Java/JavaVirtualMachines"
JDKS=( $(ls ${JDKS_DIR}) )
JDKS_STATES=()

# Map state of JDK
for (( i = 0; i < ${#JDKS[@]}; i++ )); do
	if [[ -f "${JDKS_DIR}/${JDKS[$i]}/Contents/Info.plist" ]]; then
		JDKS_STATES[${i}]=enable
	else
		JDKS_STATES[${i}]=disable
	fi
	echo "${i} ${JDKS[$i]} ${JDKS_STATES[$i]}"
done

# Declare variables
DEFAULT_JDK_DIR=""
DEFAULT_JDK=""
OPTION=""

# OPTION for default jdk and set variables
while [[ ! "$OPTION" =~ ^[0-9]+$ || OPTION -ge "${#JDKS[@]}" ]]; do
	read -p "Enter Default JDK: "  OPTION
	if [[ ! "$OPTION" =~ ^[0-9]+$  ]]; then
		echo "Sorry integers only"
	fi

	if [[ OPTION -ge "${#JDKS[@]}" ]]; then
		echo "Out of index"
	fi
done

DEFAULT_JDK_DIR="${JDKS_DIR}/${JDKS[$OPTION]}"
DEFAULT_JDK="${JDKS[$OPTION]}"

# Disable all jdk
for (( i = 0; i < ${#JDKS[@]}; i++ )); do
	if [[ -f "${JDKS_DIR}/${JDKS[$i]}/Contents/Info.plist" ]]; then
		sudo mv "${JDKS_DIR}/${JDKS[$i]}/Contents/Info.plist" "${JDKS_DIR}/${JDKS[$i]}/Contents/Info.plist.disable"
	fi
done

# Enable default jdk
if [[ -f "${DEFAULT_JDK_DIR}/Contents/Info.plist.disable" ]]; then
	sudo mv "${DEFAULT_JDK_DIR}/Contents/Info.plist.disable" "${DEFAULT_JDK_DIR}/Contents/Info.plist"
	echo "Enable ${DEFAULT_JDK} as default JDK"
fi
