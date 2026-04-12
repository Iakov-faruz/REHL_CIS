#!/usr/bin/env bash
# CIS Benchmark: 6.3.1.3 - Audit backlog_limit
# CIS Benchmark: 6.3.1.4 - auditd service enabled/active
# CIS Benchmark: 6.3.2.1 - Audit log storage size
# CIS Benchmark: 6.3.2.2 - Audit logs not auto-deleted
# CIS Benchmark: 6.3.2.3 - System disabled when audit logs full
# CIS Benchmark: 6.3.2.4 - System warns on low audit log space
# Level: 2

PASS=0
FAIL=0

echo "=================================================="
echo " CIS 6.3.1-6.3.2 - auditd Service & Data Retention"
echo "=================================================="

# 6.3.1.3 - audit_backlog_limit
echo ""
echo "--- 6.3.1.3: audit_backlog_limit ---"
backlog=$(grubby --info=ALL 2>/dev/null | grep -Po '\baudit_backlog_limit=\d+\b' | head -1)
if [ -n "$backlog" ]; then
    bl_val=$(echo "$backlog" | grep -Po '\d+')
    if [ "$bl_val" -ge 8192 ]; then
        echo "[PASS] $backlog (>= 8192)"
        ((PASS++))
    else
        echo "[FAIL] $backlog (should be >= 8192)"
        ((FAIL++))
    fi
else
    echo "[FAIL] audit_backlog_limit not set in grub"
    ((FAIL++))
fi

# 6.3.1.4 - auditd enabled and active
echo ""
echo "--- 6.3.1.4: auditd service ---"
auditd_enabled=$(systemctl is-enabled auditd 2>/dev/null)
auditd_active=$(systemctl is-active auditd 2>/dev/null)
if [ "$auditd_enabled" = "enabled" ] && [ "$auditd_active" = "active" ]; then
    echo "[PASS] auditd is enabled and active"
    ((PASS++))
else
    echo "[FAIL] auditd - enabled=$auditd_enabled, active=$auditd_active"
    ((FAIL++))
fi

AUDIT_CONF="/etc/audit/auditd.conf"
if [ ! -f "$AUDIT_CONF" ]; then
    echo "[FAIL] $AUDIT_CONF not found"
    exit 1
fi

# 6.3.2.1 - max_log_file
echo ""
echo "--- 6.3.2.1: max_log_file ---"
mlf=$(grep -Po -- '^\h*max_log_file\h*=\h*\d+' $AUDIT_CONF)
if [ -n "$mlf" ]; then
    echo "[REVIEW] $mlf (verify compliant with site policy)"
    ((PASS++))
else
    echo "[FAIL] max_log_file not configured"
    ((FAIL++))
fi

# 6.3.2.2 - max_log_file_action = keep_logs
echo ""
echo "--- 6.3.2.2: max_log_file_action ---"
mlfa=$(grep -Pi -- '^\h*max_log_file_action\h*=\h*keep_logs' $AUDIT_CONF)
if [ -n "$mlfa" ]; then
    echo "[PASS] max_log_file_action = keep_logs"
    ((PASS++))
else
    echo "[FAIL] max_log_file_action is not set to keep_logs"
    ((FAIL++))
fi

# 6.3.2.3 - disk_full_action and disk_error_action
echo ""
echo "--- 6.3.2.3: disk_full_action / disk_error_action ---"
dfa=$(grep -P -- '^\h*disk_full_action\h*=\h*(halt|single)\b' $AUDIT_CONF)
dea=$(grep -P -- '^\h*disk_error_action\h*=\h*(syslog|single|halt)\b' $AUDIT_CONF)
if [ -n "$dfa" ]; then
    echo "[PASS] $dfa"
    ((PASS++))
else
    echo "[FAIL] disk_full_action not set to halt or single"
    ((FAIL++))
fi
if [ -n "$dea" ]; then
    echo "[PASS] $dea"
    ((PASS++))
else
    echo "[FAIL] disk_error_action not set to syslog, single, or halt"
    ((FAIL++))
fi

# 6.3.2.4 - space_left_action and admin_space_left_action
echo ""
echo "--- 6.3.2.4: space_left_action / admin_space_left_action ---"
sla=$(grep -P -- '^\h*space_left_action\h*=\h*(email|exec|single|halt)\b' $AUDIT_CONF)
asla=$(grep -P -- '^\h*admin_space_left_action\h*=\h*(single|halt)\b' $AUDIT_CONF)
if [ -n "$sla" ]; then
    echo "[PASS] $sla"
    ((PASS++))
else
    echo "[FAIL] space_left_action not set to email/exec/single/halt"
    ((FAIL++))
fi
if [ -n "$asla" ]; then
    echo "[PASS] $asla"
    ((PASS++))
else
    echo "[FAIL] admin_space_left_action not set to single/halt"
    ((FAIL++))
fi

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
