#!/usr/bin/env bash
# CIS Benchmark: 6.2.1.1 - Ensure journald service is enabled and active
# Level: 1 - Server | 1 - Workstation

echo "====================================================="
echo " CIS 6.2.1.1 - Enable and Start journald"
echo "====================================================="

systemctl unmask systemd-journald.service
systemctl start systemd-journald.service

# Verify result
active_status=$(systemctl is-active systemd-journald.service 2>/dev/null)
if [[ "$active_status" == "active" ]]; then
    echo "[DONE] systemd-journald.service is now active."
else
    echo "[ERROR] Failed to start systemd-journald.service. Status: $active_status"
fi
