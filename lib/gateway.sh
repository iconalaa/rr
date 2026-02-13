#!/usr/bin/env bash

install_gateway_api() {
    log_info "Installing Gateway API CRDs..."
    kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml
    log_info "Gateway API installed successfully."
}
