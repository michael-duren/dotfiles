#!/usr/bin/env bash
set -euo pipefail
if (( EUID != 0 )); then
    echo "Run with sudo: sudo bash $0" >&2
    exit 1
fi
install -d /etc/modules-load.d /etc/udev/rules.d
printf '%s\n' uinput > /etc/modules-load.d/weylus.conf
# Give the active local desktop user access through logind.
printf '%s\n' 'KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"' > /etc/udev/rules.d/70-weylus.rules
modprobe uinput
udevadm control --reload-rules
udevadm trigger --action=add --subsystem-match=misc --sysname-match=uinput
udevadm settle
ufw allow from 192.168.20.0/24 to any port 1701 proto tcp comment "Weylus local network"
ls -l /dev/uinput
