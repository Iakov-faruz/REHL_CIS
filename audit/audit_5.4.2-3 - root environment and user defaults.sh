#!/usr/bin/env bash
# CIS Benchmark: 5.4.2.5-5.4.3.3 - Root Environment and User Defaults Audit
# Covers: 5.4.2.5 (root PATH), 5.4.2.6 (root umask), 5.4.2.7 (system account shells),
#         5.4.2.8 (lock accounts without login shell), 5.4.3.1 (nologin not in /etc/shells),
#         5.4.3.2 (TMOUT), 5.4.3.3 (default user umask)
# Level: 1

PASS=0
FAIL=0

echo "======================================================"
echo " CIS 5.4.2.5-5.4.3.3 - Root Env & User Defaults Audit"
echo "======================================================"

# 5.4.2.5 - Root PATH integrity
echo ""; echo "--- 5.4.2.5: Root PATH Integrity ---"
l_root_path="$(sudo -Hiu root env 2>/dev/null | grep '^PATH' | cut -d= -f2)"
path_fail=0
echo "$l_root_path" | grep -q "::" && { echo "[FAIL] Root PATH contains empty dir (::)"; ((path_fail++)); }
echo "$l_root_path" | grep -Pq ':\h*$' && { echo "[FAIL] Root PATH has trailing (:)"; ((path_fail++)); }
echo "$l_root_path" | grep -Pq '(\h+|:)\.(:|$)' && { echo "[FAIL] Root PATH contains (.)"; ((path_fail++)); }
if [ "$path_fail" -eq 0 ]; then
    echo "[PASS] Root PATH integrity OK"
    ((PASS++))
else
    ((FAIL++))
fi

# 5.4.2.6 - Root umask
echo ""; echo "--- 5.4.2.6: Root User umask ---"
bad_root_umask=$(grep -Psi -- '^\h*umask\h+(([0-7][0-7][01][0-7]\b|[0-7][0-7][0-7][0-6]\b)|([0-7][01][0-7]\b|[0-7][0-7][0-6]\b)|(u=[rwx]{1,3},)?(((g=[rx]?[rx]?w[rx]?[rx]?\b)(,o=[rwx]{1,3})?)|((g=[wrx]{1,3},)?o=[wrx]{1,3}\b)))' /root/.bash_profile /root/.bashrc 2>/dev/null)
if [ -z "$bad_root_umask" ]; then
    echo "[PASS] Root umask is not set too permissively"
    ((PASS++))
else
    echo "[FAIL] Root umask too permissive:"
    echo "$bad_root_umask"
    ((FAIL++))
fi

# 5.4.2.7 - System accounts without valid login shell
echo ""; echo "--- 5.4.2.7: System Account Shells ---"
l_valid_shells="^($( awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\/{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"
bad_sys_shells=$(awk -v pat="$l_valid_shells" -F: '($1!~/^(root|halt|sync|shutdown|nfsnobody)$/ && ($3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"' || $3 == 65534) && $(NF) ~ pat) {print $1 " -> " $7}' /etc/passwd 2>/dev/null)
if [ -z "$bad_sys_shells" ]; then
    echo "[PASS] All system accounts have nologin shell"
    ((PASS++))
else
    echo "[FAIL] System accounts with valid login shell:"
    echo "$bad_sys_shells"
    ((FAIL++))
fi

# 5.4.2.8 - Accounts without login shell should be locked
echo ""; echo "--- 5.4.2.8: Accounts Without Shell Locked ---"
unlocked=0
while IFS= read -r l_user; do
    status=$(passwd -S "$l_user" 2>/dev/null | awk '{print $2}')
    if [[ "$status" != "L" && "$status" != "LK" ]]; then
        echo "[FAIL] $l_user has no valid shell but is not locked (status: $status)"
        ((unlocked++))
    fi
done < <(awk -v pat="$l_valid_shells" -F: '($1 != "root" && $(NF) !~ pat) {print $1}' /etc/passwd)
if [ "$unlocked" -eq 0 ]; then
    echo "[PASS] All accounts without login shell are locked"
    ((PASS++))
else
    ((FAIL++))
fi

# 5.4.3.1 - nologin not in /etc/shells
echo ""; echo "--- 5.4.3.1: nologin in /etc/shells ---"
nologin_shells=$(grep -Ps '^\h*([^#\n\r]+)?\/nologin\b' /etc/shells 2>/dev/null)
if [ -z "$nologin_shells" ]; then
    echo "[PASS] nologin is not listed in /etc/shells"
    ((PASS++))
else
    echo "[FAIL] nologin found in /etc/shells"
    ((FAIL++))
fi

# 5.4.3.2 - TMOUT
echo ""; echo "--- 5.4.3.2: Shell Timeout (TMOUT) ---"
tmout_set=$(grep -Pls -- '^([^#\n\r]+)?\bTMOUT\b' /etc/*bashrc /etc/profile /etc/profile.d/*.sh 2>/dev/null)
if [ -n "$tmout_set" ]; then
    tmout_val=$(grep -Po -- '^([^#\n\r]+)?\bTMOUT=\d+\b' $tmout_set 2>/dev/null | head -1 | awk -F= '{print $2}')
    if [ -n "$tmout_val" ] && [ "$tmout_val" -le 900 ] && [ "$tmout_val" -gt 0 ]; then
        echo "[PASS] TMOUT=$tmout_val (in: $tmout_set)"
        ((PASS++))
    else
        echo "[FAIL] TMOUT set to $tmout_val (should be 1-900)"
        ((FAIL++))
    fi
else
    echo "[FAIL] TMOUT is not configured"
    ((FAIL++))
fi

# 5.4.3.3 - Default user umask
echo ""; echo "--- 5.4.3.3: Default User umask ---"
umask_ok=$(grep -Psi -- '^\h*umask\h+(0?[0-7][2-7]7|u(=[rwx]{0,3}),g=([rx]{0,2}),o=)(\h*#.*)?$' /etc/profile.d/*.sh /etc/profile /etc/bashrc /etc/login.defs 2>/dev/null | head -1)
if [ -n "$umask_ok" ]; then
    echo "[PASS] Default umask: $umask_ok"
    ((PASS++))
else
    echo "[FAIL] Default umask not set to 027 or more restrictive"
    ((FAIL++))
fi

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
