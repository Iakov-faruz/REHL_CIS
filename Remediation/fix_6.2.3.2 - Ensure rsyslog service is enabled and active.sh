#!/usr/bin/env bash
# CIS 6.2.3.2 - Ensure rsyslog service is enabled and active
echo "=== CIS 6.2.3.2 - Ensure rsyslog service is enabled and active ==="
systemctl unmask rsyslog; systemctl enable --now rsyslog
echo "[DONE] rsyslog started and enabled"
