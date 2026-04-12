#!/usr/bin/env bash
# CIS 5.4.2.7 - Ensure system accounts do not have a valid login shell
PASS=0; FAIL=0
echo "=== CIS 5.4.2.7 - Ensure system accounts do not have a valid login shell ==="
if [ -z "$(awk -F: '($1!~/^(root|halt|sync|shutdown|nfsnobody)$/ && $3<1000 && $7!~/(nologin|false)$/) {print $1}' /etc/passwd)" ]; then echo "[PASS] System accounts have invalid shell"; ((PASS++))
else echo "[FAIL] System accounts have valid shell"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
