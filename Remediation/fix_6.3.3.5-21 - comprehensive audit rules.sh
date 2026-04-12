#!/usr/bin/env bash
# CIS Benchmark: 6.3.3.5-6.3.3.21 - Comprehensive Audit Rules Remediation
# Level: 2

echo "=============================================="
echo " CIS 6.3.3.5-6.3.3.21 - Configure All Audit Rules"
echo "=============================================="

RULES_DIR="/etc/audit/rules.d"
mkdir -p "$RULES_DIR"

UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
[ -z "$UID_MIN" ] && { echo "[ERROR] UID_MIN not set"; exit 1; }

# 6.3.3.5 - Network environment changes
echo "[INFO] 6.3.3.5: Network environment rules..."
cat > "$RULES_DIR/50-system_locale.rules" <<EOF
-a always,exit -F arch=b64 -S sethostname,setdomainname -k system-locale
-a always,exit -F arch=b32 -S sethostname,setdomainname -k system-locale
-w /etc/issue -p wa -k system-locale
-w /etc/issue.net -p wa -k system-locale
-w /etc/hosts -p wa -k system-locale
-w /etc/hostname -p wa -k system-locale
-w /etc/sysconfig/network -p wa -k system-locale
-w /etc/sysconfig/network-scripts/ -p wa -k system-locale
-w /etc/NetworkManager -p wa -k system-locale
EOF

# 6.3.3.6 - Privileged commands
echo "[INFO] 6.3.3.6: Privileged commands rules..."
AUDIT_RULE_FILE="$RULES_DIR/50-privileged.rules"
> "$AUDIT_RULE_FILE"
for PARTITION in $(findmnt -n -l -k -it $(awk '/nodev/ { print $2 }' /proc/filesystems | paste -sd,) 2>/dev/null | grep -Pv "noexec|nosuid" | awk '{print $1}'); do
    find "$PARTITION" -xdev -perm /6000 -type f 2>/dev/null | while read -r PRIV; do
        echo "-a always,exit -F path=$PRIV -F perm=x -F auid>=$UID_MIN -F auid!=unset -k privileged"
    done
done | sort -u >> "$AUDIT_RULE_FILE"

# 6.3.3.7 - Unsuccessful file access
echo "[INFO] 6.3.3.7: File access rules..."
cat > "$RULES_DIR/50-access.rules" <<EOF
-a always,exit -F arch=b64 -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=$UID_MIN -F auid!=unset -k access
-a always,exit -F arch=b64 -S creat,open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=$UID_MIN -F auid!=unset -k access
-a always,exit -F arch=b32 -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=$UID_MIN -F auid!=unset -k access
-a always,exit -F arch=b32 -S creat,open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=$UID_MIN -F auid!=unset -k access
EOF

# 6.3.3.8 - User/group information changes
echo "[INFO] 6.3.3.8: Identity rules..."
cat > "$RULES_DIR/50-identity.rules" <<'EOF'
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/security/opasswd -p wa -k identity
-w /etc/nsswitch.conf -p wa -k identity
-w /etc/pam.conf -p wa -k identity
-w /etc/pam.d -p wa -k identity
EOF

# 6.3.3.9 - DAC permission modifications
echo "[INFO] 6.3.3.9: DAC permission modification rules..."
cat > "$RULES_DIR/50-perm_mod.rules" <<EOF
-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=$UID_MIN -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S chown,fchown,lchown,fchownat -F auid>=$UID_MIN -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=$UID_MIN -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b32 -S lchown,fchown,chown,fchownat -F auid>=$UID_MIN -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=$UID_MIN -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b32 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=$UID_MIN -F auid!=unset -F key=perm_mod
EOF

# 6.3.3.10 - File system mounts
echo "[INFO] 6.3.3.10: Mount rules..."
cat > "$RULES_DIR/50-mounts.rules" <<EOF
-a always,exit -F arch=b64 -S mount -F auid>=$UID_MIN -F auid!=unset -k mounts
-a always,exit -F arch=b32 -S mount -F auid>=$UID_MIN -F auid!=unset -k mounts
EOF

# 6.3.3.11 - Session initiation
echo "[INFO] 6.3.3.11: Session rules..."
cat > "$RULES_DIR/50-session.rules" <<'EOF'
-w /var/run/utmp -p wa -k session
-w /var/log/wtmp -p wa -k session
-w /var/log/btmp -p wa -k session
EOF

# 6.3.3.12 - Login/logout events
echo "[INFO] 6.3.3.12: Login rules..."
cat > "$RULES_DIR/50-login.rules" <<'EOF'
-w /var/log/lastlog -p wa -k logins
-w /var/run/faillock -p wa -k logins
EOF

# 6.3.3.13 - File deletion events
echo "[INFO] 6.3.3.13: File deletion rules..."
cat > "$RULES_DIR/50-delete.rules" <<EOF
-a always,exit -F arch=b64 -S rename,unlink,unlinkat,renameat -F auid>=$UID_MIN -F auid!=unset -F key=delete
-a always,exit -F arch=b32 -S rename,unlink,unlinkat,renameat -F auid>=$UID_MIN -F auid!=unset -F key=delete
EOF

# 6.3.3.14 - MAC policy changes
echo "[INFO] 6.3.3.14: MAC policy rules..."
cat > "$RULES_DIR/50-MAC-policy.rules" <<'EOF'
-w /etc/selinux -p wa -k MAC-policy
-w /usr/share/selinux -p wa -k MAC-policy
EOF

# 6.3.3.15-6.3.3.17 - chcon, setfacl, chacl
echo "[INFO] 6.3.3.15-6.3.3.17: Permission change commands..."
cat > "$RULES_DIR/50-perm_chng.rules" <<EOF
-a always,exit -F path=/usr/bin/chcon -F perm=x -F auid>=$UID_MIN -F auid!=unset -k perm_chng
-a always,exit -F path=/usr/bin/setfacl -F perm=x -F auid>=$UID_MIN -F auid!=unset -k perm_chng
-a always,exit -F path=/usr/bin/chacl -F perm=x -F auid>=$UID_MIN -F auid!=unset -k perm_chng
EOF

# 6.3.3.18 - usermod
echo "[INFO] 6.3.3.18: usermod rules..."
cat > "$RULES_DIR/50-usermod.rules" <<EOF
-a always,exit -F path=/usr/sbin/usermod -F perm=x -F auid>=$UID_MIN -F auid!=unset -k usermod
EOF

# 6.3.3.19 - Kernel module operations
echo "[INFO] 6.3.3.19: Kernel module rules..."
cat > "$RULES_DIR/50-kernel_modules.rules" <<EOF
-a always,exit -F arch=b64 -S init_module,finit_module,delete_module,create_module,query_module -F auid>=$UID_MIN -F auid!=unset -k kernel_modules
-a always,exit -F arch=b32 -S init_module,finit_module,delete_module,create_module,query_module -F auid>=$UID_MIN -F auid!=unset -k kernel_modules
-a always,exit -F path=/usr/bin/kmod -F perm=x -F auid>=$UID_MIN -F auid!=unset -k kernel_modules
EOF

# 6.3.3.20 - Make audit config immutable
echo "[INFO] 6.3.3.20: Immutable config (-e 2)..."
cat > "$RULES_DIR/99-finalize.rules" <<'EOF'
-e 2
EOF

# Load all rules
echo "[INFO] 6.3.3.21: Loading all audit rules..."
augenrules --load

# Check if reboot required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    echo "[WARN] Reboot required to load rules (audit config locked -e 2)."
fi

echo "[DONE] All audit rules configured."
