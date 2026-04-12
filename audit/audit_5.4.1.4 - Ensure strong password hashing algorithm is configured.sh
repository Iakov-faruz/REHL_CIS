#!/usr/bin/env bash
# CIS 5.4.1.4 - Ensure strong password hashing algorithm is configured
PASS=0; FAIL=0
echo "=== CIS 5.4.1.4 - Ensure strong password hashing algorithm is configured ==="
em=$(grep -Pi '^\s*ENCRYPT_METHOD\s+(SHA512|yescrypt)' /etc/login.defs)
if [ -n "$em" ]; then echo "[PASS] ENCRYPT_METHOD is SHA512/yescrypt"; ((PASS++))
else echo "[FAIL] ENCRYPT_METHOD not SHA512/yescrypt"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
