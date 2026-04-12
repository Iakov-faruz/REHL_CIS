#!/usr/bin/env bash
# CIS Benchmark: 7.2.4-7.2.9 - Extended User/Group Audit
# Covers: 7.2.4 (dup UIDs), 7.2.5 (dup GIDs), 7.2.6 (dup usernames),
#         7.2.7 (dup group names), 7.2.8 (home dirs), 7.2.9 (dot files)
# Level: 1

PASS=0
FAIL=0

echo "=============================================="
echo " CIS 7.2.4-7.2.9 - Extended User/Group Audit"
echo "=============================================="

# 7.2.4 - Duplicate UIDs
echo ""; echo "--- 7.2.4: Duplicate UIDs ---"
dup_uids=$(cut -f3 -d":" /etc/passwd | sort -n | uniq -d)
if [ -z "$dup_uids" ]; then
    echo "[PASS] No duplicate UIDs"
    ((PASS++))
else
    echo "[FAIL] Duplicate UIDs found:"
    while read -r uid; do
        echo "  UID $uid: $(awk -F: -v u="$uid" '$3==u{print $1}' /etc/passwd | xargs)"
    done <<< "$dup_uids"
    ((FAIL++))
fi

# 7.2.5 - Duplicate GIDs
echo ""; echo "--- 7.2.5: Duplicate GIDs ---"
dup_gids=$(cut -f3 -d":" /etc/group | sort -n | uniq -d)
if [ -z "$dup_gids" ]; then
    echo "[PASS] No duplicate GIDs"
    ((PASS++))
else
    echo "[FAIL] Duplicate GIDs found:"
    while read -r gid; do
        echo "  GID $gid: $(awk -F: -v g="$gid" '$3==g{print $1}' /etc/group | xargs)"
    done <<< "$dup_gids"
    ((FAIL++))
fi

# 7.2.6 - Duplicate user names
echo ""; echo "--- 7.2.6: Duplicate User Names ---"
dup_users=$(cut -f1 -d":" /etc/passwd | sort | uniq -d)
if [ -z "$dup_users" ]; then
    echo "[PASS] No duplicate user names"
    ((PASS++))
else
    echo "[FAIL] Duplicate user names: $dup_users"
    ((FAIL++))
fi

# 7.2.7 - Duplicate group names
echo ""; echo "--- 7.2.7: Duplicate Group Names ---"
dup_groups=$(cut -f1 -d":" /etc/group | sort | uniq -d)
if [ -z "$dup_groups" ]; then
    echo "[PASS] No duplicate group names"
    ((PASS++))
else
    echo "[FAIL] Duplicate group names: $dup_groups"
    ((FAIL++))
fi

# 7.2.8 - Home directories exist, owned by user, mode <= 0750
echo ""; echo "--- 7.2.8: Home Directory Configuration ---"
l_valid_shells="^($( awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\/{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"
home_fail=0
while read -r l_user l_home; do
    if [ -d "$l_home" ]; then
        l_own=$(stat -Lc '%U' "$l_home")
        l_mode=$(stat -Lc '%#a' "$l_home")
        [ "$l_user" != "$l_own" ] && { echo "[FAIL] $l_home owned by $l_own (should be $l_user)"; ((home_fail++)); }
        if [ $(( $l_mode & 0027 )) -gt 0 ]; then
            echo "[FAIL] $l_home mode $l_mode (should be 0750 or more restrictive)"
            ((home_fail++))
        fi
    else
        [ "$l_home" != "/" ] && echo "[FAIL] User $l_user home $l_home does not exist" && ((home_fail++))
    fi
done <<< "$(awk -v pat="$l_valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd)"
if [ "$home_fail" -eq 0 ]; then
    echo "[PASS] All home directories properly configured"
    ((PASS++))
else
    ((FAIL++))
fi

# 7.2.9 - Dot files (simplified check)
echo ""; echo "--- 7.2.9: Dot File Access ---"
dot_fail=0
while read -r l_user l_home; do
    [ ! -d "$l_home" ] && continue
    # Check for .forward and .rhost
    for badfile in .forward .rhost; do
        [ -f "$l_home/$badfile" ] && { echo "[FAIL] $l_home/$badfile exists"; ((dot_fail++)); }
    done
done <<< "$(awk -v pat="$l_valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd)"
if [ "$dot_fail" -eq 0 ]; then
    echo "[PASS] No .forward or .rhost files found"
    ((PASS++))
else
    ((FAIL++))
fi

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
