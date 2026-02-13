#!/usr/bin/env bash

LOG_FILE="/var/log/rke2-airk8a2-bootstrap.log"

log_info() {
    echo -e "\e[32m[INFO]\e[0m $1"
    echo "[INFO] $1" >> "$LOG_FILE"
}

log_warn() {
    echo -e "\e[33m[WARN]\e[0m $1"
    echo "[WARN] $1" >> "$LOG_FILE"
}

log_error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
    echo "[ERROR] $1" >> "$LOG_FILE"
}

trap 'log_error "Script failed at line $LINENO"; exit 1' ERR

check_root() {
    if [[ "$EUID" -ne 0 ]]; then
        log_error "Please run as root."
        exit 1
    fi
}

check_ubuntu() {
    if ! grep -q "Ubuntu" /etc/os-release; then
        log_error "This script supports Ubuntu only."
        exit 1
    fi
}

check_dependencies() {
    REQUIRED=(curl wget kubectl helm jq)
    for dep in "${REQUIRED[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            log_warn "$dep not installed. Installing..."
            apt-get update && apt-get install -y "$dep"
        fi
    done
}

select_option() {
    local options=("$@")
    local selected=0
    while true; do
        clear
        for i in "${!options[@]}"; do
            if [[ $i -eq $selected ]]; then
                echo "> ${options[$i]}"
            else
                echo "  ${options[$i]}"
            fi
        done

        read -rsn1 key
        if [[ $key == $'\x1b' ]]; then
            read -rsn2 key
            case $key in
                "[A") ((selected--));;
                "[B") ((selected++));;
            esac
        elif [[ $key == "" ]]; then
            return $selected
        fi

        ((selected<0)) && selected=$((${#options[@]}-1))
        ((selected>=${#options[@]})) && selected=0
    done
}
