#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/lib/rke2.sh"
source "${SCRIPT_DIR}/lib/istio.sh"
source "${SCRIPT_DIR}/lib/gateway.sh"

export CLUSTER_VERSION="AirK8A2"

log_info "Starting RKE2 (AirK8A2) Cluster Bootstrap..."

check_root
check_ubuntu
check_dependencies

main_menu() {
    OPTIONS=(
        "Install RKE2 Server"
        "Install CNI"
        "Install Gateway API + CRDs"
        "Install Istio Controller"
        "Full Production Setup"
        "Exit"
    )

    select_option "${OPTIONS[@]}"
    case $? in
        0) install_rke2 ;;
        1) install_cni_menu ;;
        2) install_gateway_api ;;
        3) install_istio ;;
        4)
            install_rke2
            install_cni_menu
            install_gateway_api
            install_istio
            ;;
        5) exit 0 ;;
    esac
}

install_cni_menu() {
    CNIS=("Calico" "Cilium" "Canal" "Cancel")

    select_option "${CNIS[@]}"
    case $? in
        0) install_calico ;;
        1) install_cilium ;;
        2) install_canal ;;
        3) return ;;
    esac
}

while true; do
    main_menu
done
