#!/usr/bin/env bash
# CIS Benchmark: 6.3.4.x - Fix Audit Log/Config/Tools Permissions
# Level: 2

echo "========================================================="
echo " CIS 6.3.4.x - Fix Audit Permissions"
echo "========================================================="

AUDIT_CONF="/etc/audit/auditd.conf"
AUDIT_TOOLS=(/sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules)

if [ ! -f "$AUDIT_CONF" ]; then
    echo "[ERROR] $AUDIT_CONF not found."
    exit 1
fi

LOG_DIR=$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' $AUDIT_CONF | xargs)")

# 6.3.4.1 - Fix audit log directory mode
echo "[INFO] 6.3.4.1: Setting audit log directory permissions..."
chmod g-w,o-rwx "$LOG_DIR"

# 6.3.4.2 - Fix audit log files mode
echo "[INFO] 6.3.4.2: Setting audit log files permissions..."
find "$LOG_DIR" -maxdepth 1 -type f -perm /0137 -exec chmod u-x,g-wx,o-rwx {} +

# 6.3.4.3 - Fix audit log files owner
echo "[INFO] 6.3.4.3: Setting audit log files owner..."
find "$LOG_DIR" -maxdepth 1 -type f ! -user root -exec chown root {} +

# 6.3.4.4 - Fix audit log files group + log_group
echo "[INFO] 6.3.4.4: Setting audit log files group..."
find "$LOG_DIR" -type f \( ! -group adm -a ! -group root \) -exec chgrp adm {} +
chgrp adm "$LOG_DIR"
sed -ri 's/^\s*#?\s*log_group\s*=\s*\S+(\s*#.*)?.*$/log_group = adm\1/' "$AUDIT_CONF"

# 6.3.4.5 - Fix audit config files mode
echo "[INFO] 6.3.4.5: Setting audit config files permissions..."
find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) -exec chmod u-x,g-wx,o-rwx {} +

# 6.3.4.6 - Fix audit config files owner
echo "[INFO] 6.3.4.6: Setting audit config files owner..."
find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -user root -exec chown root {} +

# 6.3.4.7 - Fix audit config files group
echo "[INFO] 6.3.4.7: Setting audit config files group..."
find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -group root -exec chgrp root {} +

# 6.3.4.8 - Fix audit tools mode
echo "[INFO] 6.3.4.8: Setting audit tools permissions..."
chmod go-w "${AUDIT_TOOLS[@]}" 2>/dev/null

# 6.3.4.9 - Fix audit tools owner
echo "[INFO] 6.3.4.9: Setting audit tools owner..."
chown root "${AUDIT_TOOLS[@]}" 2>/dev/null

# 6.3.4.10 - Fix audit tools group
echo "[INFO] 6.3.4.10: Setting audit tools group..."
chgrp root "${AUDIT_TOOLS[@]}" 2>/dev/null

systemctl restart auditd
echo "[DONE] All audit permissions fixed."
