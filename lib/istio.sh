#!/usr/bin/env bash

install_istio() {
    log_info "Installing Istio..."

    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.20.0 sh -
    cd istio-1.20.0
    export PATH=$PWD/bin:$PATH

    istioctl install --set profile=default -y

    kubectl label namespace default istio-injection=enabled --overwrite

    log_info "Istio installed successfully."
}
