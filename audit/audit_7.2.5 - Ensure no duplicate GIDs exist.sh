#!/usr/bin/env bash
# CIS 7.2.5 - Ensure no duplicate GIDs exist
PASS=0; FAIL=0
echo "=== CIS 7.2.5 - Ensure no duplicate GIDs exist ==="
dup=$(cut -f3 -d":" /etc/group | sort -n | uniq -d)
if [ -z "$dup" ]; then echo "[PASS] No duplicate GIDs"; ((PASS++))
else echo "[FAIL] Duplicate GIDs:"; while read -r gid; do echo "  GID $gid: $(awk -F: -v g=\"$gid\" '$3==g{print $1}' /etc/group | xargs)"; done <<< "$dup"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
