#!/usr/bin/env bash
# CIS Benchmark: 6.3.3.x - Audit Rules Audit
# Covers: 6.3.3.1 (sudoers scope), 6.3.3.2 (user emulation),
#         6.3.3.3 (sudo log), 6.3.3.4 (date/time changes)
# Level: 2

PASS=0
FAIL=0

echo "=============================================="
echo " CIS 6.3.3.x - Audit Rules Configuration"
echo "=============================================="

# 6.3.3.1 - sudoers scope
echo ""
echo "--- 6.3.3.1: Sudoers Scope ---"
scope_disk=$(awk '/^ *-w/ && /\/etc\/sudoers/ && / +-p *wa/ && (/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules 2>/dev/null)
scope_run=$(auditctl -l 2>/dev/null | awk '/^ *-w/ && /\/etc\/sudoers/ && / +-p *wa/ && (/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)')
if echo "$scope_disk" | grep -q 'sudoers' && echo "$scope_run" | grep -q 'sudoers'; then
    echo "[PASS] Sudoers scope monitoring rules found"
    ((PASS++))
else
    echo "[FAIL] Sudoers scope monitoring rules missing"
    [ -z "$scope_disk" ] && echo "  - On disk: MISSING"
    [ -z "$scope_run" ] && echo "  - Running: MISSING"
    ((FAIL++))
fi

# 6.3.3.2 - User emulation (execve with euid!=uid)
echo ""
echo "--- 6.3.3.2: User Emulation ---"
emu_disk=$(awk '/^ *-a *always,exit/ && / -F *arch=b(32|64)/ && (/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) && (/ -C *euid!=uid/||/ -C *uid!=euid/) && / -S *execve/ && (/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules 2>/dev/null)
if [ -n "$emu_disk" ]; then
    echo "[PASS] User emulation rules found on disk"
    ((PASS++))
else
    echo "[FAIL] User emulation rules missing on disk"
    ((FAIL++))
fi

# 6.3.3.3 - Sudo log file
echo ""
echo "--- 6.3.3.3: Sudo Log File Monitoring ---"
SUDO_LOG_FILE=$(grep -r logfile /etc/sudoers* 2>/dev/null | sed -e 's/.*logfile=//;s/,? .*//' -e 's/"//g' | head -1)
if [ -n "$SUDO_LOG_FILE" ]; then
    sudo_escaped=$(echo "$SUDO_LOG_FILE" | sed 's|/|\\/|g')
    sudo_disk=$(awk "/^ *-w/ && /${sudo_escaped}/ && / +-p *wa/ && (/ key= *[!-~]* *\$/||/ -k *[!-~]* *\$/)/" /etc/audit/rules.d/*.rules 2>/dev/null)
    if [ -n "$sudo_disk" ]; then
        echo "[PASS] Sudo log ($SUDO_LOG_FILE) monitoring rule found"
        ((PASS++))
    else
        echo "[FAIL] Sudo log ($SUDO_LOG_FILE) monitoring rule missing"
        ((FAIL++))
    fi
else
    echo "[INFO] No sudo logfile configured in /etc/sudoers"
fi

# 6.3.3.4 - Date/time changes
echo ""
echo "--- 6.3.3.4: Date/Time Changes ---"
time_disk=$(awk '/^ *-a *always,exit/ && / -F *arch=b(32|64)/ && / -S/ && (/adjtimex/ || /settimeofday/ || /clock_settime/) && (/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules 2>/dev/null)
time_localtime=$(awk '/^ *-w/ && /\/etc\/localtime/ && / +-p *wa/ && (/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules 2>/dev/null)
if [ -n "$time_disk" ] && [ -n "$time_localtime" ]; then
    echo "[PASS] Date/time change rules found"
    ((PASS++))
else
    echo "[FAIL] Date/time change rules missing"
    [ -z "$time_disk" ] && echo "  - System call rules: MISSING"
    [ -z "$time_localtime" ] && echo "  - /etc/localtime watch: MISSING"
    ((FAIL++))
fi

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
