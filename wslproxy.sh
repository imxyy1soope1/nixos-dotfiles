#!/bin/sh

sudo mkdir -p /run/systemd/system/nix-daemon.service.d
sudo su -c 'cat << EOF >/run/systemd/system/nix-daemon.service.d/override.conf
[Service]
Environment="http_proxy=http://192.168.128.1:7890"
Environment="https_proxy=http://192.168.128.1:7890"
Environment="all_proxy=socks5h://192.168.128.1:7890"
EOF'
sudo systemctl daemon-reload
sudo systemctl restart nix-daemon
