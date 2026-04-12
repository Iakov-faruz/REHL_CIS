#!/usr/bin/env bash
# CIS Benchmark: 7.2.x - Local User and Group Settings Audit
# Covers: 7.2.1 (shadowed passwords), 7.2.2 (empty shadow passwords),
#         7.2.3 (groups in passwd exist in group)
# Level: 1

PASS=0
FAIL=0

echo "=============================================="
echo " CIS 7.2.x - Local User and Group Audit"
echo "=============================================="

# 7.2.1 - Shadowed passwords
echo ""
echo "--- 7.2.1: Shadowed Passwords ---"
non_shadow=$(awk -F: '($2 != "x" ) { print "User: \"" $1 "\" is not set to shadowed passwords "}' /etc/passwd)
if [ -z "$non_shadow" ]; then
    echo "[PASS] All accounts use shadowed passwords"
    ((PASS++))
else
    echo "[FAIL] Accounts not using shadowed passwords:"
    echo "$non_shadow"
    ((FAIL++))
fi

# 7.2.2 - Empty shadow password fields
echo ""
echo "--- 7.2.2: Empty Password Fields ---"
empty_pw=$(awk -F: '($2 == "" ) { print $1 " does not have a password "}' /etc/shadow)
if [ -z "$empty_pw" ]; then
    echo "[PASS] No accounts have empty password fields"
    ((PASS++))
else
    echo "[FAIL] Accounts with empty passwords:"
    echo "$empty_pw"
    ((FAIL++))
fi

# 7.2.3 - All groups in /etc/passwd exist in /etc/group
echo ""
echo "--- 7.2.3: Groups Consistency ---"
missing_groups=""
while IFS=: read -r user _ _ gid _ _ _; do
    if ! grep -q ":${gid}:" /etc/group 2>/dev/null && ! awk -F: -v g="$gid" '$3==g{found=1} END{exit !found}' /etc/group; then
        missing_groups="${missing_groups}\n  User '$user' has GID $gid not in /etc/group"
    fi
done < /etc/passwd

if [ -z "$missing_groups" ]; then
    echo "[PASS] All groups referenced in /etc/passwd exist in /etc/group"
    ((PASS++))
else
    echo "[FAIL] Missing groups:$missing_groups"
    ((FAIL++))
fi

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
