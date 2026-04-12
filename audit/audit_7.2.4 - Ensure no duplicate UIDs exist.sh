#!/usr/bin/env bash
# CIS 7.2.4 - Ensure no duplicate UIDs exist
PASS=0; FAIL=0
echo "=== CIS 7.2.4 - Ensure no duplicate UIDs exist ==="
dup=$(cut -f3 -d":" /etc/passwd | sort -n | uniq -d)
if [ -z "$dup" ]; then echo "[PASS] No duplicate UIDs"; ((PASS++))
else echo "[FAIL] Duplicate UIDs:"; while read -r uid; do echo "  UID $uid: $(awk -F: -v u=\"$uid\" '$3==u{print $1}' /etc/passwd | xargs)"; done <<< "$dup"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
