#!/usr/bin/env bash
FAILED=0

echo "CHECK 1 - SELINUXTYPE is targeted or mls in /etc/selinux/config:"
RESULT=$(grep -E '^\s*SELINUXTYPE=(targeted|mls)\b' /etc/selinux/config)
if [ -n "$RESULT" ]; then
    echo "CHECK 1 - SELINUXTYPE in config: PASS ($RESULT)"
else
    echo "CHECK 1 - SELINUXTYPE in config: FAIL"
    FAILED=1
fi

echo "CHECK 2 - Loaded SELinux policy is targeted or mls:"
RESULT=$(sestatus | grep Loaded)
if echo "$RESULT" | grep -Eq '(targeted|mls)'; then
    echo "CHECK 2 - Loaded policy: PASS ($RESULT)"
else
    echo "CHECK 2 - Loaded policy: FAIL ($RESULT)"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.3.1.3 Ensure SELinux policy is configured: PASS"
else
    echo "OVERALL - 1.3.1.3 Ensure SELinux policy is configured: FAIL"
fi
