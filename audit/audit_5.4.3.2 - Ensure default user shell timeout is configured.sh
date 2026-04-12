#!/usr/bin/env bash
# CIS 5.4.3.2 - Ensure default user shell timeout is configured
PASS=0; FAIL=0
echo "=== CIS 5.4.3.2 - Ensure default user shell timeout is configured ==="
res=$(grep -Po 'TMOUT=\d+' /etc/profile.d/*.sh /etc/profile /etc/bashrc 2>/dev/null | head -1)
if [ -n "$res" ] && [ "$(echo "$res" | cut -d= -f2)" -le 900 ]; then echo "[PASS] TMOUT configured"; ((PASS++))
else echo "[FAIL] TMOUT missing or too large"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
