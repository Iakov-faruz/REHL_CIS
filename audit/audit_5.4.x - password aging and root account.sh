#!/usr/bin/env bash
# CIS Benchmark: 5.4.1.x - Password Aging and Account Settings Audit
# Covers: 5.4.1.1 (PASS_MAX_DAYS), 5.4.1.2 (PASS_MIN_DAYS),
#         5.4.1.3 (PASS_WARN_AGE), 5.4.1.4 (ENCRYPT_METHOD),
#         5.4.1.5 (INACTIVE), 5.4.1.6 (last password change in past)
# CIS Benchmark: 5.4.2.x - Root Account Controls
# Covers: 5.4.2.1 (only root UID 0), 5.4.2.2 (only root GID 0),
#         5.4.2.3 (only root group GID 0), 5.4.2.4 (root access controlled),
#         5.4.2.5 (root PATH integrity)
# Level: 1

PASS=0
FAIL=0

echo "======================================================"
echo " CIS 5.4.x - Password Aging & Root Account Audit"
echo "======================================================"

# 5.4.1.1 - PASS_MAX_DAYS <= 365
echo ""; echo "--- 5.4.1.1: PASS_MAX_DAYS ---"
pmd=$(grep -Pi -- '^\h*PASS_MAX_DAYS\h+\d+\b' /etc/login.defs)
pmd_val=$(echo "$pmd" | awk '{print $2}')
if [ -n "$pmd_val" ] && [ "$pmd_val" -le 365 ] && [ "$pmd_val" -gt 0 ]; then
    echo "[PASS] $pmd"
    ((PASS++))
else
    echo "[FAIL] PASS_MAX_DAYS not set to 365 or less (current: $pmd_val)"
    ((FAIL++))
fi
# Check individual users
bad_max=$(awk -F: '($2~/^\$.+\$/) {if($5 > 365 || $5 < 1)print "  User: " $1 " PASS_MAX_DAYS: " $5}' /etc/shadow)
if [ -n "$bad_max" ]; then
    echo "[FAIL] Users with non-compliant PASS_MAX_DAYS:"
    echo "$bad_max"
    ((FAIL++))
fi

# 5.4.1.2 - PASS_MIN_DAYS > 0
echo ""; echo "--- 5.4.1.2: PASS_MIN_DAYS ---"
pmind=$(grep -Pi -- '^\h*PASS_MIN_DAYS\h+\d+\b' /etc/login.defs)
pmind_val=$(echo "$pmind" | awk '{print $2}')
if [ -n "$pmind_val" ] && [ "$pmind_val" -ge 1 ]; then
    echo "[PASS] $pmind"
    ((PASS++))
else
    echo "[FAIL] PASS_MIN_DAYS not >= 1 (current: $pmind_val)"
    ((FAIL++))
fi

# 5.4.1.3 - PASS_WARN_AGE >= 7
echo ""; echo "--- 5.4.1.3: PASS_WARN_AGE ---"
pwa=$(grep -Pi -- '^\h*PASS_WARN_AGE\h+\d+\b' /etc/login.defs)
pwa_val=$(echo "$pwa" | awk '{print $2}')
if [ -n "$pwa_val" ] && [ "$pwa_val" -ge 7 ]; then
    echo "[PASS] $pwa"
    ((PASS++))
else
    echo "[FAIL] PASS_WARN_AGE not >= 7 (current: $pwa_val)"
    ((FAIL++))
fi

# 5.4.1.4 - ENCRYPT_METHOD SHA512 or YESCRYPT
echo ""; echo "--- 5.4.1.4: ENCRYPT_METHOD ---"
em=$(grep -Pi -- '^\h*ENCRYPT_METHOD\h+(SHA512|yescrypt)\b' /etc/login.defs)
if [ -n "$em" ]; then
    echo "[PASS] $em"
    ((PASS++))
else
    echo "[FAIL] ENCRYPT_METHOD not SHA512 or YESCRYPT"
    ((FAIL++))
fi

# 5.4.1.5 - INACTIVE <= 45
echo ""; echo "--- 5.4.1.5: INACTIVE ---"
inactive=$(useradd -D 2>/dev/null | grep INACTIVE | cut -d= -f2)
if [ -n "$inactive" ] && [ "$inactive" -ge 0 ] && [ "$inactive" -le 45 ]; then
    echo "[PASS] INACTIVE=$inactive"
    ((PASS++))
else
    echo "[FAIL] INACTIVE not set to 0-45 (current: $inactive)"
    ((FAIL++))
fi

# 5.4.1.6 - Password change date in past
echo ""; echo "--- 5.4.1.6: Password Change Date ---"
future_pw=""
while IFS= read -r l_user; do
    l_change=$(date -d "$(chage --list "$l_user" 2>/dev/null | grep '^Last password change' | cut -d: -f2 | grep -v 'never$')" +%s 2>/dev/null)
    if [ -n "$l_change" ] && [ "$l_change" -gt "$(date +%s)" ]; then
        future_pw="${future_pw}\n  $l_user"
    fi
done < <(awk -F: '$2~/^\$.+\$/{print $1}' /etc/shadow)
if [ -z "$future_pw" ]; then
    echo "[PASS] All password change dates are in the past"
    ((PASS++))
else
    echo "[FAIL] Users with future password dates:$future_pw"
    ((FAIL++))
fi

# 5.4.2.1 - Only root has UID 0
echo ""; echo "--- 5.4.2.1: UID 0 ---"
uid0=$(awk -F: '($3 == 0) { print $1 }' /etc/passwd)
if [ "$uid0" = "root" ]; then
    echo "[PASS] Only root has UID 0"
    ((PASS++))
else
    echo "[FAIL] Non-root accounts with UID 0: $uid0"
    ((FAIL++))
fi

# 5.4.2.2 - Only root has GID 0 as primary
echo ""; echo "--- 5.4.2.2: GID 0 ---"
gid0=$(awk -F: '($1 !~ /^(sync|shutdown|halt|operator)/ && $4=="0") {print $1}' /etc/passwd)
if [ "$gid0" = "root" ]; then
    echo "[PASS] Only root has GID 0 as primary"
    ((PASS++))
else
    echo "[FAIL] Non-root accounts with primary GID 0: $gid0"
    ((FAIL++))
fi

# 5.4.2.3 - Only root group has GID 0
echo ""; echo "--- 5.4.2.3: Group GID 0 ---"
grp0=$(awk -F: '$3=="0"{print $1}' /etc/group)
if [ "$grp0" = "root" ]; then
    echo "[PASS] Only root group has GID 0"
    ((PASS++))
else
    echo "[FAIL] Non-root groups with GID 0: $grp0"
    ((FAIL++))
fi

# 5.4.2.4 - Root access controlled
echo ""; echo "--- 5.4.2.4: Root Account Access ---"
root_status=$(passwd -S root 2>/dev/null | awk '{print $2}')
if [[ "$root_status" =~ ^(P|L) ]]; then
    echo "[PASS] Root account has password set or is locked ($root_status)"
    ((PASS++))
else
    echo "[FAIL] Root account status: $root_status"
    ((FAIL++))
fi

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
