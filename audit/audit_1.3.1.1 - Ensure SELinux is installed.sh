#!/usr/bin/env bash
FAILED=0

echo "CHECK - libselinux is installed:"
RESULT=$(rpm -q libselinux)
if echo "$RESULT" | grep -q "^libselinux-"; then
    echo "CHECK - libselinux is installed: PASS ($RESULT)"
else
    echo "CHECK - libselinux is installed: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.3.1.1 Ensure SELinux is installed: PASS"
else
    echo "OVERALL - 1.3.1.1 Ensure SELinux is installed: FAIL"
fi
