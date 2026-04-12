#!/usr/bin/env bash
# CIS 5.1.9 - Ensure sshd ClientAliveInterval and ClientAliveCountMax are configured (Audit)

echo "=== CIS 5.1.9 - Auditing ClientAliveInterval and ClientAliveCountMax ==="
RESULT=$(sshd -T 2>/dev/null | grep -Pi -- '(clientaliveinterval|clientalivecountmax)')
echo "$RESULT"

INTERVAL=$(sshd -T 2>/dev/null | awk '$1 == "clientaliveinterval" {print $2}')
COUNTMAX=$(sshd -T 2>/dev/null | awk '$1 == "clientalivecountmax" {print $2}')

FAIL=0
if [ -z "$INTERVAL" ] || [ "$INTERVAL" -eq 0 ] 2>/dev/null; then
    echo " - FAIL: ClientAliveInterval is 0 or not set"
    FAIL=1
else
    echo " - PASS: ClientAliveInterval is $INTERVAL"
fi

if [ -z "$COUNTMAX" ] || [ "$COUNTMAX" -eq 0 ] 2>/dev/null; then
    echo " - FAIL: ClientAliveCountMax is 0 or not set"
    FAIL=1
else
    echo " - PASS: ClientAliveCountMax is $COUNTMAX"
fi

[ "$FAIL" -eq 0 ] && echo " - Overall: PASS" || echo " - Overall: FAIL"
