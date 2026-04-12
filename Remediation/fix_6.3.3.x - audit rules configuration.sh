#!/usr/bin/env bash
# CIS Benchmark: 6.3.3.x - Configure Audit Rules
# Covers: 6.3.3.1 (sudoers scope), 6.3.3.2 (user emulation),
#         6.3.3.3 (sudo log), 6.3.3.4 (date/time changes)
# Level: 2

echo "=============================================="
echo " CIS 6.3.3.x - Configure Audit Rules"
echo "=============================================="

RULES_DIR="/etc/audit/rules.d"
mkdir -p "$RULES_DIR"

# 6.3.3.1 - Sudoers scope
echo "[INFO] 6.3.3.1: Adding sudoers scope rules..."
printf '%s\n' "-w /etc/sudoers -p wa -k scope" "-w /etc/sudoers.d -p wa -k scope" > "$RULES_DIR/50-scope.rules"

# 6.3.3.2 - User emulation
echo "[INFO] 6.3.3.2: Adding user emulation rules..."
cat > "$RULES_DIR/50-user_emulation.rules" <<'EOF'
-a always,exit -F arch=b64 -C euid!=uid -F auid!=unset -S execve -k user_emulation
-a always,exit -F arch=b32 -C euid!=uid -F auid!=unset -S execve -k user_emulation
EOF

# 6.3.3.3 - Sudo log file
echo "[INFO] 6.3.3.3: Adding sudo log file rules..."
SUDO_LOG_FILE=$(grep -r logfile /etc/sudoers* 2>/dev/null | sed -e 's/.*logfile=//;s/,? .*//' -e 's/"//g' | head -1)
if [ -n "$SUDO_LOG_FILE" ]; then
    printf '%s\n' "-w ${SUDO_LOG_FILE} -p wa -k sudo_log_file" > "$RULES_DIR/50-sudo.rules"
    echo "  Monitoring: $SUDO_LOG_FILE"
else
    echo "  [WARN] No sudo logfile configured. Set 'Defaults logfile=/var/log/sudo.log' in /etc/sudoers first."
    printf '%s\n' "-w /var/log/sudo.log -p wa -k sudo_log_file" > "$RULES_DIR/50-sudo.rules"
fi

# 6.3.3.4 - Date/time changes
echo "[INFO] 6.3.3.4: Adding date/time change rules..."
cat > "$RULES_DIR/50-time-change.rules" <<'EOF'
-a always,exit -F arch=b64 -S adjtimex,settimeofday -k time-change
-a always,exit -F arch=b32 -S adjtimex,settimeofday -k time-change
-a always,exit -F arch=b64 -S clock_settime -F a0=0x0 -k time-change
-a always,exit -F arch=b32 -S clock_settime -F a0=0x0 -k time-change
-w /etc/localtime -p wa -k time-change
EOF

# Load all rules
echo "[INFO] Loading audit rules..."
augenrules --load

# Check if reboot required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    echo "[WARN] Reboot required to load rules (audit config is locked -e 2)."
fi

echo "[DONE] Audit rules configured."
