#!/usr/bin/env bash
# CIS 6.2.3.4 - Ensure rsyslog log file creation mode is configured
echo "=== CIS 6.2.3.4 - Ensure rsyslog log file creation mode is configured ==="
sed -ri 's/^\s*\$FileCreateMode.*$/\$FileCreateMode 0640/' /etc/rsyslog.conf 2>/dev/null
if ! grep -qs '^\s*\$FileCreateMode\s+0640' /etc/rsyslog.conf; then
    echo "\$FileCreateMode 0640" >> /etc/rsyslog.conf
fi
systemctl restart rsyslog
echo "[DONE] \$FileCreateMode 0640 configured"
