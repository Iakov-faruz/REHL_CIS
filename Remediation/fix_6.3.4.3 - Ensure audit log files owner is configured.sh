#!/usr/bin/env bash
# CIS 6.3.4.3 - Ensure audit log files owner is configured
echo "=== CIS 6.3.4.3 - Fix Audit Log Files Owner ==="
AUDIT_CONF="/etc/audit/auditd.conf"
[ ! -f "$AUDIT_CONF" ] && { echo "[ERROR] $AUDIT_CONF not found"; exit 1; }
LOG_DIR=$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' $AUDIT_CONF | xargs)")
find "$LOG_DIR" -maxdepth 1 -type f ! -user root -exec chown root {} +
echo "[DONE] All audit log files owned by root"
