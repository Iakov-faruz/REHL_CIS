#!/usr/bin/env bash
# CIS 6.2.3.3 - Ensure rsyslog default file permissions configured
echo "=== CIS 6.2.3.3 - Fix rsyslog file permissions ==="
sed -ri 's/^\s*\$FileCreateMode.*$/\$FileCreateMode 0640/' /etc/rsyslog.conf 2>/dev/null
if ! grep -qs '^\s*\$FileCreateMode\s+0640' /etc/rsyslog.conf; then
    echo "\$FileCreateMode 0640" >> /etc/rsyslog.conf
fi
systemctl restart rsyslog
echo "[DONE] \$FileCreateMode 0640 configured"
