#!/usr/bin/env bash
# CIS 6.2.3.1 - Ensure rsyslog is installed
echo "=== CIS 6.2.3.1 - Ensure rsyslog is installed ==="
dnf install -y rsyslog
echo "[DONE] rsyslog installed"
