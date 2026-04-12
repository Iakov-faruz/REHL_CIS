#!/usr/bin/env bash
# CIS 6.2.2.1.1 - Ensure systemd-journal-remote is installed
echo "=== CIS 6.2.2.1.1 - Ensure systemd-journal-remote is installed ==="
dnf install -y systemd-journal-remote
echo "[DONE] systemd-journal-remote installed"
