#!/usr/bin/env bash
# CIS 6.2.2.1.3 - Ensure systemd-journal-upload is enabled and active
echo "=== CIS 6.2.2.1.3 - Ensure systemd-journal-upload is enabled and active ==="
systemctl unmask systemd-journal-upload; systemctl enable --now systemd-journal-upload
echo "[DONE] systemd-journal-upload enabled"
