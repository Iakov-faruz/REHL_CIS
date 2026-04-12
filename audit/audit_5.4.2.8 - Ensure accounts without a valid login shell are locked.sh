#!/usr/bin/env bash
# CIS 5.4.2.8 - Ensure accounts without a valid login shell are locked
PASS=0; FAIL=0
echo "=== CIS 5.4.2.8 - Ensure accounts without a valid login shell are locked ==="
unlocked=0; while IFS= read -r u; do st=$(passwd -S "$u" 2>/dev/null | awk '{print $2}'); [[ "$st" != "L" && "$st" != "LK" ]] && unlocked=1; done < <(awk -F: '($1!="root" && $7~/(nologin|false)$/) {print $1}' /etc/passwd); if [ $unlocked -eq 0 ]; then echo "[PASS] Accounts without login shell are locked"; ((PASS++)); else echo "[FAIL] Accounts without shell are unlocked"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
