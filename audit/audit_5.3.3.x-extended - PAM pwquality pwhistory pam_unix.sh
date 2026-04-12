#!/usr/bin/env bash
# CIS Benchmark: 5.3.3.2.5-5.3.3.2.7 + 5.3.3.3.x + 5.3.3.4.x - Extended PAM Audit
# Covers: maxsequence, dictcheck, enforce_for_root (pwquality)
#         pwhistory remember, enforce_for_root, use_authtok
#         pam_unix nullok, remember, sha512, use_authtok
# Level: 1

PASS=0
FAIL=0

echo "=============================================="
echo " CIS 5.3.3.x - Extended PAM Configuration"
echo "=============================================="

PWQUALITY_CONF="/etc/security/pwquality.conf"
PWQUALITY_DIR="/etc/security/pwquality.conf.d"
PWHISTORY_CONF="/etc/security/pwhistory.conf"

# 5.3.3.2.5 - maxsequence
echo ""; echo "--- 5.3.3.2.5: maxsequence ---"
ms=$(grep -Psi -- '^\h*maxsequence\h*=\h*[1-3]\b' "$PWQUALITY_CONF" "$PWQUALITY_DIR"/*.conf 2>/dev/null)
if [ -n "$ms" ]; then
    echo "[PASS] $ms"
    ((PASS++))
else
    echo "[FAIL] maxsequence not set to 1-3"
    ((FAIL++))
fi

# 5.3.3.2.6 - dictcheck not disabled
echo ""; echo "--- 5.3.3.2.6: dictcheck ---"
dc_bad=$(grep -Psi -- '^\h*dictcheck\h*=\h*0\b' "$PWQUALITY_CONF" "$PWQUALITY_DIR"/*.conf 2>/dev/null)
if [ -z "$dc_bad" ]; then
    echo "[PASS] dictcheck is not disabled"
    ((PASS++))
else
    echo "[FAIL] dictcheck is disabled (= 0)"
    ((FAIL++))
fi

# 5.3.3.2.7 - enforce_for_root (pwquality)
echo ""; echo "--- 5.3.3.2.7: enforce_for_root (pwquality) ---"
efr=$(grep -Psi -- '^\h*enforce_for_root\b' "$PWQUALITY_CONF" "$PWQUALITY_DIR"/*.conf 2>/dev/null)
if [ -n "$efr" ]; then
    echo "[PASS] enforce_for_root is set"
    ((PASS++))
else
    echo "[FAIL] enforce_for_root not configured"
    ((FAIL++))
fi

# 5.3.3.3.1 - pwhistory remember >= 24
echo ""; echo "--- 5.3.3.3.1: pwhistory remember ---"
if [ -f "$PWHISTORY_CONF" ]; then
    rem=$(grep -Pi -- '^\h*remember\h*=\h*(2[4-9]|[3-9][0-9]|[1-9][0-9]{2,})\b' "$PWHISTORY_CONF")
    if [ -n "$rem" ]; then
        echo "[PASS] $rem"
        ((PASS++))
    else
        echo "[FAIL] remember not set to 24 or more in $PWHISTORY_CONF"
        ((FAIL++))
    fi
else
    echo "[FAIL] $PWHISTORY_CONF not found"
    ((FAIL++))
fi

# 5.3.3.3.2 - enforce_for_root (pwhistory)
echo ""; echo "--- 5.3.3.3.2: enforce_for_root (pwhistory) ---"
efr_h=$(grep -Pi -- '^\h*enforce_for_root\b' "$PWHISTORY_CONF" 2>/dev/null)
if [ -n "$efr_h" ]; then
    echo "[PASS] enforce_for_root in pwhistory"
    ((PASS++))
else
    echo "[FAIL] enforce_for_root not in pwhistory.conf"
    ((FAIL++))
fi

# 5.3.3.3.3 - pam_pwhistory use_authtok
echo ""; echo "--- 5.3.3.3.3: pam_pwhistory use_authtok ---"
pwhist_uat=$(grep -P -- '^\h*password\h+([^#\n\r]+)\h+pam_pwhistory\.so\h+([^#\n\r]+\h+)?use_authtok\b' /etc/pam.d/{password,system}-auth 2>/dev/null)
if [ -n "$pwhist_uat" ]; then
    echo "[PASS] pam_pwhistory includes use_authtok"
    ((PASS++))
else
    echo "[FAIL] pam_pwhistory missing use_authtok"
    ((FAIL++))
fi

# 5.3.3.4.1 - pam_unix no nullok
echo ""; echo "--- 5.3.3.4.1: pam_unix nullok ---"
nullok=$(grep -P -- '^\h*(auth|account|password|session)\h+(requisite|required|sufficient)\h+pam_unix\.so\b' /etc/pam.d/{password,system}-auth 2>/dev/null | grep -i 'nullok')
if [ -z "$nullok" ]; then
    echo "[PASS] pam_unix does not include nullok"
    ((PASS++))
else
    echo "[FAIL] pam_unix includes nullok:"
    echo "$nullok"
    ((FAIL++))
fi

# 5.3.3.4.2 - pam_unix no remember
echo ""; echo "--- 5.3.3.4.2: pam_unix remember ---"
unix_rem=$(grep -Pi '^\h*password\h+([^#\n\r]+\h+)?pam_unix\.so\b' /etc/pam.d/{password,system}-auth 2>/dev/null | grep -i 'remember=')
if [ -z "$unix_rem" ]; then
    echo "[PASS] pam_unix does not include remember"
    ((PASS++))
else
    echo "[FAIL] pam_unix includes remember (use pam_pwhistory instead)"
    ((FAIL++))
fi

# 5.3.3.4.3 - pam_unix strong hash (sha512 or yescrypt)
echo ""; echo "--- 5.3.3.4.3: pam_unix hashing ---"
hash=$(grep -P -- '^\h*password\h+([^#\n\r]+)\h+pam_unix\.so\h+([^#\n\r]+\h+)?(sha512|yescrypt)\b' /etc/pam.d/{password,system}-auth 2>/dev/null)
if [ -n "$hash" ]; then
    echo "[PASS] pam_unix uses strong hashing"
    ((PASS++))
else
    echo "[FAIL] pam_unix not using sha512 or yescrypt"
    ((FAIL++))
fi

# 5.3.3.4.4 - pam_unix use_authtok
echo ""; echo "--- 5.3.3.4.4: pam_unix use_authtok ---"
unix_uat=$(grep -P -- '^\h*password\h+([^#\n\r]+)\h+pam_unix\.so\h+([^#\n\r]+\h+)?use_authtok\b' /etc/pam.d/{password,system}-auth 2>/dev/null)
if [ -n "$unix_uat" ]; then
    echo "[PASS] pam_unix includes use_authtok"
    ((PASS++))
else
    echo "[FAIL] pam_unix missing use_authtok"
    ((FAIL++))
fi

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
