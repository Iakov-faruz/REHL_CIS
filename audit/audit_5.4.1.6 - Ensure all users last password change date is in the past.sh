#!/usr/bin/env bash
# CIS 5.4.1.6 - Ensure all users last password change date is in the past
PASS=0; FAIL=0
echo "=== CIS 5.4.1.6 - Ensure all users last password change date is in the past ==="
fail=0; while IFS= read -r u; do c=$(date -d "$(chage --list "$u"|grep '^Last pwd change'|cut -d: -f2|grep -v never)" +%s 2>/dev/null); [ -n "$c" ] && [ "$c" -gt "$(date +%s)" ] && fail=1; done < <(awk -F: '$2~/^\$.+\$/{print $1}' /etc/shadow); if [ $fail -eq 0 ]; then echo "[PASS] All pwd change dates in past"; ((PASS++)); else echo "[FAIL] Future pwd change dates found"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
