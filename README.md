# RKE2 AirK8A2 Cluster Setup

Production-ready RKE2 bootstrap framework for Ubuntu.

## Structure

production-repo/
 └── rke2-setup/
      ├── bootstrap.sh
      ├── config.env
      ├── README.md
      └── lib/
           ├── common.sh
           ├── rke2.sh
           ├── istio.sh
           └── gateway.sh

## Run

cd rke2-setup
chmod +x bootstrap.sh
sudo ./bootstrap.sh

Logs:
 /var/log/rke2-airk8a2-bootstrap.log
