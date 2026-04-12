#!/usr/bin/env bash
# CIS 6.3.4.1 - Ensure audit log directory mode is configured
echo "=== CIS 6.3.4.1 - Fix Audit Log Directory Mode ==="
AUDIT_CONF="/etc/audit/auditd.conf"
[ ! -f "$AUDIT_CONF" ] && { echo "[ERROR] $AUDIT_CONF not found"; exit 1; }
LOG_DIR=$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' $AUDIT_CONF | xargs)")
chmod g-w,o-rwx "$LOG_DIR"
echo "[DONE] $LOG_DIR permissions set to 0750 or more restrictive"
