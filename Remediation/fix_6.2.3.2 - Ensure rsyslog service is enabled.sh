#!/usr/bin/env bash
# CIS 6.2.3.2 - Ensure rsyslog service is enabled
echo "=== CIS 6.2.3.2 - Fix rsyslog enabled ==="
systemctl --now enable rsyslog
echo "[DONE] rsyslog enabled and started"
