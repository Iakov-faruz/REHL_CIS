#!/usr/bin/env bash
# CIS 5.2.3 - Ensure sudo log file exists (Remediation)
echo "=== CIS 5.2.3 - Configuring sudo log file ==="

if ! grep -rPsiq "^\h*Defaults\h+([^#]+,\h*)?logfile\h*=" /etc/sudoers* 2>/dev/null; then
    echo 'Defaults logfile="/var/log/sudo.log"' >> /etc/sudoers.d/00-cis-defaults
    echo " - Added 'Defaults logfile=\"/var/log/sudo.log\"' to /etc/sudoers.d/00-cis-defaults"
else
    echo " - INFO: sudo logfile already configured"
fi
