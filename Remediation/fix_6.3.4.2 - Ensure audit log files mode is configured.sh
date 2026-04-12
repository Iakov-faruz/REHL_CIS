#!/usr/bin/env bash
# CIS 6.3.4.2 - Ensure audit log files mode is configured
echo "=== CIS 6.3.4.2 - Fix Audit Log Files Mode ==="
AUDIT_CONF="/etc/audit/auditd.conf"
[ ! -f "$AUDIT_CONF" ] && { echo "[ERROR] $AUDIT_CONF not found"; exit 1; }
LOG_DIR=$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' $AUDIT_CONF | xargs)")
find "$LOG_DIR" -maxdepth 1 -type f -perm /0137 -exec chmod u-x,g-wx,o-rwx {} +
echo "[DONE] Audit log files set to mode 0640 or more restrictive"
