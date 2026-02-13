#!/usr/bin/env bash

install_rke2() {
    log_info "Installing RKE2 Server..."

    if systemctl is-active --quiet rke2-server; then
        log_warn "RKE2 already installed."
        return
    fi

    curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="server" sh -

    mkdir -p /etc/rancher/rke2

    cat <<EOC >/etc/rancher/rke2/config.yaml
write-kubeconfig-mode: "0644"
disable:
  - rke2-ingress-nginx
cni: none
EOC

    systemctl enable rke2-server
    systemctl start rke2-server

    export KUBECONFIG=/etc/rancher/rke2/rke2.yaml

    log_info "RKE2 installed successfully."
}

install_calico() {
    log_info "Installing Calico..."
    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml
}

install_cilium() {
    log_info "Installing Cilium..."
    helm repo add cilium https://helm.cilium.io/
    helm repo update
    helm install cilium cilium/cilium --namespace kube-system
}

install_canal() {
    log_info "Installing Canal..."
    kubectl apply -f https://docs.projectcalico.org/manifests/canal.yaml
}
