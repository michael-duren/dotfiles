#!/usr/bin/env bash
set -euo pipefail
if (( EUID != 0 )); then
    echo "Run with sudo: sudo bash $0" >&2
    exit 1
fi
pacman -Syu --needed uxplay gst-plugins-bad gst-libav
systemctl enable --now avahi-daemon.service
ufw allow from 192.168.20.0/24 to any port 5353 proto udp comment 'AirPlay discovery'
ufw allow from 192.168.20.0/24 to any port 35000:35002 proto tcp comment 'UxPlay local network'
ufw allow from 192.168.20.0/24 to any port 35000:35002 proto udp comment 'UxPlay local network'
