#!/usr/bin/env bash
# CIS Benchmark: 6.2.3.x - rsyslog Configuration Audit
# Covers: 6.2.3.1 (installed), 6.2.3.2 (enabled/active), 6.2.3.3 (ForwardToSyslog=yes),
#         6.2.3.4 (FileCreateMode), 6.2.3.7 (not receiving remote), 6.2.3.8 (logrotate)
# NOTE: Apply only if rsyslog is the chosen logging system (not journald)

PASS=0
FAIL=0

echo "============================================"
echo " CIS 6.2.3.x - rsyslog Configuration Audit"
echo "============================================"

# 6.2.3.1 - rsyslog installed
if rpm -q rsyslog &>/dev/null; then
    echo "[PASS] 6.2.3.1: rsyslog is installed: $(rpm -q rsyslog)"
    ((PASS++))
else
    echo "[FAIL] 6.2.3.1: rsyslog is NOT installed"
    ((FAIL++))
fi

# 6.2.3.2 - rsyslog enabled and active
rsyslog_enabled=$(systemctl is-enabled rsyslog 2>/dev/null)
rsyslog_active=$(systemctl is-active rsyslog.service 2>/dev/null)
if [[ "$rsyslog_enabled" == "enabled" && "$rsyslog_active" == "active" ]]; then
    echo "[PASS] 6.2.3.2: rsyslog.service is enabled and active"
    ((PASS++))
else
    echo "[FAIL] 6.2.3.2: rsyslog.service - enabled=$rsyslog_enabled, active=$rsyslog_active"
    ((FAIL++))
fi

# 6.2.3.3 - journald ForwardToSyslog=yes (when rsyslog is primary)
fwd=$(systemd-analyze cat-config systemd/journald.conf systemd/journald.conf.d/* 2>/dev/null | grep -E "^ForwardToSyslog=yes")
if [ -n "$fwd" ]; then
    echo "[PASS] 6.2.3.3: ForwardToSyslog=yes is set (journald forwards to rsyslog)"
    ((PASS++))
else
    echo "[FAIL] 6.2.3.3: ForwardToSyslog=yes is NOT set"
    ((FAIL++))
fi

# 6.2.3.4 - FileCreateMode 0640 or more restrictive
fcm=$(grep -Ps '^\h*\$FileCreateMode\h+0[0,2,4,6][0,2,4]0\b' /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null)
if [ -n "$fcm" ]; then
    echo "[PASS] 6.2.3.4: \$FileCreateMode is 0640 or more restrictive: $fcm"
    ((PASS++))
else
    echo "[FAIL] 6.2.3.4: \$FileCreateMode is not set to 0640 or more restrictive"
    ((FAIL++))
fi

# 6.2.3.7 - rsyslog NOT configured to receive remote logs
imtcp_adv=$(grep -Psi -- '^\h*module\(load=\"?imtcp\"?\)' /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null)
imtcp_leg=$(grep -Psi -- '^\h*\$ModLoad\h+imtcp\b' /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null)
if [ -z "$imtcp_adv" ] && [ -z "$imtcp_leg" ]; then
    echo "[PASS] 6.2.3.7: rsyslog is NOT configured to receive remote logs"
    ((PASS++))
else
    echo "[FAIL] 6.2.3.7: rsyslog is configured to receive remote logs (imtcp loaded)"
    echo "       Remove: module(load=\"imtcp\") and input(type=\"imtcp\" ...) from config"
    ((FAIL++))
fi

# 6.2.3.8 - logrotate configured for rsyslog
if [ -f /etc/logrotate.d/rsyslog ]; then
    echo "[PASS] 6.2.3.8: rsyslog logrotate configuration found at /etc/logrotate.d/rsyslog"
    ((PASS++))
else
    echo "[WARN] 6.2.3.8: /etc/logrotate.d/rsyslog not found (MANUAL: verify logrotate is configured)"
fi

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
