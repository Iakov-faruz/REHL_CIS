#!/usr/bin/env bash
# CIS Benchmark: 6.2.2.1.1 - Ensure systemd-journal-remote is installed
# CIS Benchmark: 6.2.2.1.3 - Ensure systemd-journal-upload is enabled and active
# CIS Benchmark: 6.2.2.1.4 - Ensure systemd-journal-remote service is not in use
# CIS Benchmark: 6.2.2.2  - Ensure journald ForwardToSyslog is disabled
# CIS Benchmark: 6.2.2.3  - Ensure journald Compress is configured
# CIS Benchmark: 6.2.2.4  - Ensure journald Storage is configured
# Level: 1 - Server | 1 - Workstation
# NOTE: Apply only if journald is the chosen logging system (not rsyslog)

PASS=0
FAIL=0

echo "================================================"
echo " CIS 6.2.2.x - journald Configuration Audit"
echo "================================================"

# 6.2.2.1.1 - systemd-journal-remote installed
if rpm -q systemd-journal-remote &>/dev/null; then
    echo "[PASS] 6.2.2.1.1: systemd-journal-remote is installed: $(rpm -q systemd-journal-remote)"
    ((PASS++))
else
    echo "[FAIL] 6.2.2.1.1: systemd-journal-remote is NOT installed"
    ((FAIL++))
fi

# 6.2.2.1.3 - systemd-journal-upload enabled and active
upload_enabled=$(systemctl is-enabled systemd-journal-upload.service 2>/dev/null)
upload_active=$(systemctl is-active systemd-journal-upload.service 2>/dev/null)
if [[ "$upload_enabled" == "enabled" && "$upload_active" == "active" ]]; then
    echo "[PASS] 6.2.2.1.3: systemd-journal-upload.service is enabled and active"
    ((PASS++))
else
    echo "[FAIL] 6.2.2.1.3: systemd-journal-upload.service - enabled=$upload_enabled, active=$upload_active"
    ((FAIL++))
fi

# 6.2.2.1.4 - journal-remote receive service not enabled
remote_enabled=$(systemctl is-enabled systemd-journal-remote.socket systemd-journal-remote.service 2>/dev/null | grep -c '^enabled')
remote_active=$(systemctl is-active systemd-journal-remote.socket systemd-journal-remote.service 2>/dev/null | grep -c '^active')
if [[ "$remote_enabled" -eq 0 && "$remote_active" -eq 0 ]]; then
    echo "[PASS] 6.2.2.1.4: systemd-journal-remote receive services are not enabled/active"
    ((PASS++))
else
    echo "[FAIL] 6.2.2.1.4: systemd-journal-remote receive service is enabled or active (should be masked)"
    ((FAIL++))
fi

# 6.2.2.2 - ForwardToSyslog=no
fwd=$(systemd-analyze cat-config systemd/journald.conf systemd/journald.conf.d/* 2>/dev/null | grep -E "^ForwardToSyslog=no")
if [ -n "$fwd" ]; then
    echo "[PASS] 6.2.2.2: ForwardToSyslog=no is set"
    ((PASS++))
else
    echo "[FAIL] 6.2.2.2: ForwardToSyslog=no is NOT set"
    ((FAIL++))
fi

# 6.2.2.3 - Compress=yes
compress=$(systemd-analyze cat-config systemd/journald.conf systemd/journald.conf.d/* 2>/dev/null | grep -E "^Compress=yes")
if [ -n "$compress" ]; then
    echo "[PASS] 6.2.2.3: Compress=yes is set"
    ((PASS++))
else
    echo "[FAIL] 6.2.2.3: Compress=yes is NOT set"
    ((FAIL++))
fi

# 6.2.2.4 - Storage=persistent
storage=$(systemd-analyze cat-config systemd/journald.conf systemd/journald.conf.d/* 2>/dev/null | grep -E "^Storage=persistent")
if [ -n "$storage" ]; then
    echo "[PASS] 6.2.2.4: Storage=persistent is set"
    ((PASS++))
else
    echo "[FAIL] 6.2.2.4: Storage=persistent is NOT set"
    ((FAIL++))
fi

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
