#!/usr/bin/env bash
# CIS 6.2.3.4 - Ensure rsyslog is configured to send logs to a remote log host
echo "=== CIS 6.2.3.4 - Fix rsyslog remote host ==="
echo "[NOTE] Manual configuration required. Replace loghost.example.com with actual host."
echo "echo '*.* @@loghost.example.com' >> /etc/rsyslog.conf"
echo "[DONE] Remediation notes provided"
