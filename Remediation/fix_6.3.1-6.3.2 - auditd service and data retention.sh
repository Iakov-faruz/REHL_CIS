#!/usr/bin/env bash
# CIS Benchmark: 6.3.1.3, 6.3.1.4, 6.3.2.1-6.3.2.4 Remediation
# Level: 2

echo "=================================================="
echo " CIS 6.3.1-6.3.2 - auditd Service & Data Retention"
echo "=================================================="

AUDIT_CONF="/etc/audit/auditd.conf"

# 6.3.1.3 - Set audit_backlog_limit
echo "[INFO] 6.3.1.3: Setting audit_backlog_limit=8192..."
grubby --update-kernel ALL --args 'audit_backlog_limit=8192'
# Also update /etc/default/grub
GRUB_FILE="/etc/default/grub"
if [ -f "$GRUB_FILE" ]; then
    if grep -Pq 'GRUB_CMDLINE_LINUX=.*\baudit_backlog_limit=' "$GRUB_FILE"; then
        sed -i 's/\baudit_backlog_limit=[0-9]*/audit_backlog_limit=8192/' "$GRUB_FILE"
    elif grep -q 'GRUB_CMDLINE_LINUX=' "$GRUB_FILE"; then
        sed -i 's/\(GRUB_CMDLINE_LINUX="[^"]*\)"/\1 audit_backlog_limit=8192"/' "$GRUB_FILE"
    fi
fi

# 6.3.1.4 - Enable auditd
echo "[INFO] 6.3.1.4: Enabling auditd..."
systemctl unmask auditd
systemctl enable auditd
systemctl start auditd

# 6.3.2.1-6.3.2.4 - Configure auditd.conf
echo "[INFO] 6.3.2.x: Configuring $AUDIT_CONF..."

# Function to set or add a config parameter
set_audit_param() {
    local param="$1" value="$2"
    if grep -Pq "^\s*$param\s*=" "$AUDIT_CONF"; then
        sed -i "s/^\s*$param\s*=.*/$param = $value/" "$AUDIT_CONF"
    else
        echo "$param = $value" >> "$AUDIT_CONF"
    fi
}

# 6.3.2.1 - Log file max size (32 MB recommended)
set_audit_param "max_log_file" "32"

# 6.3.2.2 - Keep all logs
set_audit_param "max_log_file_action" "keep_logs"

# 6.3.2.3 - Actions when disk is full/error
set_audit_param "disk_full_action" "halt"
set_audit_param "disk_error_action" "halt"

# 6.3.2.4 - Warn when low on space
set_audit_param "space_left_action" "email"
set_audit_param "admin_space_left_action" "single"
set_audit_param "space_left" "75"

systemctl restart auditd
echo "[DONE] auditd service and data retention configured."
