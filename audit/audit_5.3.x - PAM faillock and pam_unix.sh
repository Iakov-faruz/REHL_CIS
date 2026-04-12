#!/usr/bin/env bash
# CIS Benchmark: 5.3.3.1.x - pam_faillock Configuration Audit
# Covers: 5.3.3.1.1 (deny), 5.3.3.1.2 (unlock_time), 5.3.3.1.3 (even_deny_root)
# CIS Benchmark: 5.3.2.5 - pam_unix enabled
# Level: 1-2

PASS=0
FAIL=0

echo "=============================================="
echo " CIS 5.3.x - PAM faillock & pam_unix Audit"
echo "=============================================="

FAILLOCK_CONF="/etc/security/faillock.conf"

# 5.3.2.5 - pam_unix enabled
echo ""
echo "--- 5.3.2.5: pam_unix module ---"
pam_unix_check=$(grep -P -- '\bpam_unix\.so\b' /etc/pam.d/{password,system}-auth 2>/dev/null)
if [ -n "$pam_unix_check" ]; then
    echo "[PASS] pam_unix.so is configured in PAM files"
    ((PASS++))
else
    echo "[FAIL] pam_unix.so not found in PAM configuration"
    ((FAIL++))
fi

# 5.3.3.1.1 - deny (max failed attempts <= 5)
echo ""
echo "--- 5.3.3.1.1: Password Failed Attempts Lockout ---"
if [ -f "$FAILLOCK_CONF" ]; then
    deny_val=$(grep -Pi -- '^\h*deny\h*=\h*[1-5]\b' "$FAILLOCK_CONF")
    if [ -n "$deny_val" ]; then
        echo "[PASS] $deny_val"
        ((PASS++))
    else
        echo "[FAIL] deny not set to 5 or less in $FAILLOCK_CONF"
        ((FAIL++))
    fi
else
    echo "[FAIL] $FAILLOCK_CONF not found"
    ((FAIL++))
fi
# Check PAM files don't override
pam_deny_override=$(grep -Pi -- '^\h*auth\h+(requisite|required|sufficient)\h+pam_faillock\.so\h+([^#\n\r]+\h+)?deny\h*=\h*(0|[6-9]|[1-9][0-9]+)\b' /etc/pam.d/system-auth /etc/pam.d/password-auth 2>/dev/null)
if [ -n "$pam_deny_override" ]; then
    echo "[FAIL] PAM files override deny with too-high value:"
    echo "$pam_deny_override"
    ((FAIL++))
fi

# 5.3.3.1.2 - unlock_time (0=never or >= 900)
echo ""
echo "--- 5.3.3.1.2: Password Unlock Time ---"
if [ -f "$FAILLOCK_CONF" ]; then
    unlock_val=$(grep -Pi -- '^\h*unlock_time\h*=\h*(0|9[0-9][0-9]|[1-9][0-9]{3,})\b' "$FAILLOCK_CONF")
    if [ -n "$unlock_val" ]; then
        echo "[PASS] $unlock_val"
        ((PASS++))
    else
        echo "[FAIL] unlock_time not set to 0 or >= 900 in $FAILLOCK_CONF"
        ((FAIL++))
    fi
fi

# 5.3.3.1.3 - even_deny_root
echo ""
echo "--- 5.3.3.1.3: Root Account Lockout ---"
if [ -f "$FAILLOCK_CONF" ]; then
    edr=$(grep -Pi -- '^\h*(even_deny_root|root_unlock_time\h*=\h*\d+)\b' "$FAILLOCK_CONF")
    if [ -n "$edr" ]; then
        echo "[PASS] Root lockout configured: $edr"
        ((PASS++))
    else
        echo "[FAIL] even_deny_root not configured in $FAILLOCK_CONF"
        ((FAIL++))
    fi
fi

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
