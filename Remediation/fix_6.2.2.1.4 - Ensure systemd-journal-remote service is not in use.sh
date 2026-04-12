#!/usr/bin/env bash
# CIS 6.2.2.1.4 - Ensure systemd-journal-remote service is not in use
echo "=== CIS 6.2.2.1.4 - Ensure systemd-journal-remote service is not in use ==="
systemctl stop systemd-journal-remote.socket systemd-journal-remote.service; systemctl disable systemd-journal-remote.socket systemd-journal-remote.service; systemctl mask systemd-journal-remote.socket systemd-journal-remote.service
echo "[DONE] systemd-journal-remote disabled"
