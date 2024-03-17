#!/bin/sh

sudo rm -rf /run/systemd/system/nix-daemon.service.d
sudo systemctl daemon-reload
sudo systemctl restart nix-daemon
