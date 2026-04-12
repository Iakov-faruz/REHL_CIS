#!/usr/bin/env bash
# CIS 6.3.4.4 - Ensure audit log files group owner is configured
echo "=== CIS 6.3.4.4 - Fix Audit Log Files Group ==="
AUDIT_CONF="/etc/audit/auditd.conf"
[ ! -f "$AUDIT_CONF" ] && { echo "[ERROR] $AUDIT_CONF not found"; exit 1; }
LOG_DIR=$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' $AUDIT_CONF | xargs)")
find "$LOG_DIR" -type f \( ! -group adm -a ! -group root \) -exec chgrp adm {} +
chgrp adm "$LOG_DIR"
sed -ri 's/^\s*#?\s*log_group\s*=\s*\S+(\s*#.*)?.*$/log_group = adm\1/' "$AUDIT_CONF"
systemctl restart auditd
echo "[DONE] Audit log files group set to adm"
