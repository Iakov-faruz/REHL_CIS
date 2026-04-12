#!/usr/bin/env bash
# CIS 5.2.1 - Ensure sudo is installed (Audit)

echo "=== CIS 5.2.1 - Auditing sudo installation ==="
if dnf list sudo 2>/dev/null | grep -q "Installed"; then
    echo " - PASS: sudo is installed"
    rpm -q sudo
else
    echo " - FAIL: sudo is NOT installed"
fi
