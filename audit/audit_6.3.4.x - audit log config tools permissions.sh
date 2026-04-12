#!/usr/bin/env bash
# CIS Benchmark: 6.3.4.x - Audit Log and Config File Permissions
# Covers: 6.3.4.1 (dir mode), 6.3.4.2 (file mode), 6.3.4.3 (file owner),
#         6.3.4.4 (file group), 6.3.4.5 (config mode), 6.3.4.6 (config owner),
#         6.3.4.7 (config group), 6.3.4.8 (tools mode), 6.3.4.9 (tools owner),
#         6.3.4.10 (tools group)
# Level: 2

PASS=0
FAIL=0

echo "========================================================="
echo " CIS 6.3.4.x - Audit Log/Config/Tools Permissions Audit"
echo "========================================================="

AUDIT_CONF="/etc/audit/auditd.conf"
AUDIT_TOOLS=(/sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules)

if [ ! -f "$AUDIT_CONF" ]; then
    echo "[FAIL] $AUDIT_CONF not found. Install auditd first."
    exit 1
fi

LOG_DIR=$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' $AUDIT_CONF | xargs)")

# 6.3.4.1 - Audit log directory mode <= 0750
echo ""
echo "--- 6.3.4.1: Audit log directory mode ---"
if [ -d "$LOG_DIR" ]; then
    dir_mode=$(stat -Lc '%#a' "$LOG_DIR")
    if [ $(( $dir_mode & 0027 )) -gt 0 ]; then
        echo "[FAIL] Directory $LOG_DIR mode: $dir_mode (should be 0750 or more restrictive)"
        ((FAIL++))
    else
        echo "[PASS] Directory $LOG_DIR mode: $dir_mode"
        ((PASS++))
    fi
else
    echo "[FAIL] Log directory $LOG_DIR not found"
    ((FAIL++))
fi

# 6.3.4.2 - Audit log files mode <= 0640
echo ""
echo "--- 6.3.4.2: Audit log files mode ---"
bad_files=$(find "$LOG_DIR" -maxdepth 1 -type f -perm /0137 2>/dev/null)
if [ -z "$bad_files" ]; then
    echo "[PASS] All audit log files are mode 0640 or more restrictive"
    ((PASS++))
else
    echo "[FAIL] Files with excess permissions:"
    echo "$bad_files"
    ((FAIL++))
fi

# 6.3.4.3 - Audit log files owner root
echo ""
echo "--- 6.3.4.3: Audit log files owner ---"
bad_owner=$(find "$LOG_DIR" -maxdepth 1 -type f ! -user root 2>/dev/null)
if [ -z "$bad_owner" ]; then
    echo "[PASS] All audit log files owned by root"
    ((PASS++))
else
    echo "[FAIL] Files not owned by root:"
    echo "$bad_owner"
    ((FAIL++))
fi

# 6.3.4.4 - Audit log files group root or adm
echo ""
echo "--- 6.3.4.4: Audit log files group ---"
bad_group=$(find "$LOG_DIR" -maxdepth 1 -type f \( ! -group root -a ! -group adm \) 2>/dev/null)
log_group=$(awk -F= '/^\s*log_group\s*/{print $2}' $AUDIT_CONF | xargs)
if echo "$log_group" | grep -Pq '^(root|adm)$'; then
    echo "[PASS] log_group is set to: $log_group"
    ((PASS++))
else
    echo "[FAIL] log_group is: $log_group (should be root or adm)"
    ((FAIL++))
fi
if [ -z "$bad_group" ]; then
    echo "[PASS] All audit log files group owned by root or adm"
    ((PASS++))
else
    echo "[FAIL] Files with wrong group:"
    echo "$bad_group"
    ((FAIL++))
fi

# 6.3.4.5 - Audit config files mode <= 0640
echo ""
echo "--- 6.3.4.5: Audit config files mode ---"
bad_conf=$(find /etc/audit/ -type f \( -name "*.conf" -o -name '*.rules' \) -perm /0137 2>/dev/null)
if [ -z "$bad_conf" ]; then
    echo "[PASS] All audit config files are mode 0640 or more restrictive"
    ((PASS++))
else
    echo "[FAIL] Config files with excess permissions:"
    echo "$bad_conf"
    ((FAIL++))
fi

# 6.3.4.6 - Audit config files owner root
echo ""
echo "--- 6.3.4.6: Audit config files owner ---"
bad_conf_owner=$(find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -user root 2>/dev/null)
if [ -z "$bad_conf_owner" ]; then
    echo "[PASS] All audit config files owned by root"
    ((PASS++))
else
    echo "[FAIL] Config files not owned by root:"
    echo "$bad_conf_owner"
    ((FAIL++))
fi

# 6.3.4.7 - Audit config files group root
echo ""
echo "--- 6.3.4.7: Audit config files group ---"
bad_conf_group=$(find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -group root 2>/dev/null)
if [ -z "$bad_conf_group" ]; then
    echo "[PASS] All audit config files group owned by root"
    ((PASS++))
else
    echo "[FAIL] Config files not group owned by root:"
    echo "$bad_conf_group"
    ((FAIL++))
fi

# 6.3.4.8 - Audit tools mode <= 0755
echo ""
echo "--- 6.3.4.8: Audit tools mode ---"
for tool in "${AUDIT_TOOLS[@]}"; do
    [ ! -f "$tool" ] && continue
    t_mode=$(stat -Lc '%#a' "$tool")
    if [ $(( $t_mode & 0022 )) -gt 0 ]; then
        echo "[FAIL] $tool mode: $t_mode (should be 0755 or more restrictive)"
        ((FAIL++))
    else
        echo "[PASS] $tool mode: $t_mode"
        ((PASS++))
    fi
done

# 6.3.4.9 - Audit tools owner root
echo ""
echo "--- 6.3.4.9: Audit tools owner ---"
bad_tool_owner=$(stat -Lc "%n %U" "${AUDIT_TOOLS[@]}" 2>/dev/null | awk '$2 != "root" {print}')
if [ -z "$bad_tool_owner" ]; then
    echo "[PASS] All audit tools owned by root"
    ((PASS++))
else
    echo "[FAIL] Tools not owned by root: $bad_tool_owner"
    ((FAIL++))
fi

# 6.3.4.10 - Audit tools group root
echo ""
echo "--- 6.3.4.10: Audit tools group ---"
bad_tool_group=$(stat -Lc "%n %G" "${AUDIT_TOOLS[@]}" 2>/dev/null | awk '$2 != "root" {print}')
if [ -z "$bad_tool_group" ]; then
    echo "[PASS] All audit tools group owned by root"
    ((PASS++))
else
    echo "[FAIL] Tools not group owned by root: $bad_tool_group"
    ((FAIL++))
fi

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
