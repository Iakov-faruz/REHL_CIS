#!/usr/bin/env bash
FAILED=0

echo "CHECK - selinux=0 and enforcing=0 are NOT set in bootloader:"
RESULT=$(grubby --info=ALL | grep -Po '(selinux|enforcing)=0\b')
if [ -z "$RESULT" ]; then
    echo "CHECK - selinux=0 and enforcing=0 not in bootloader: PASS"
else
    echo "CHECK - selinux=0 and enforcing=0 not in bootloader: FAIL"
    echo "$RESULT"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.3.1.2 Ensure SELinux is not disabled in bootloader configuration: PASS"
else
    echo "OVERALL - 1.3.1.2 Ensure SELinux is not disabled in bootloader configuration: FAIL"
fi
