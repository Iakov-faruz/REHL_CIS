#!/usr/bin/env bash
# CIS 5.2.2 - Ensure sudo commands use pty (Audit)

echo "=== CIS 5.2.2 - Auditing sudo use_pty ==="
RESULT=$(grep -rPi -- '^\h*Defaults\h+([^#\n\r]+,\h*)?use_pty\b' /etc/sudoers* 2>/dev/null)
if [ -n "$RESULT" ]; then
    echo " - PASS: Defaults use_pty is set:"
    echo "   $RESULT"
else
    echo " - FAIL: Defaults use_pty is NOT set in /etc/sudoers*"
fi

# Check that !use_pty is not set
NORESULT=$(grep -rPi -- '^\h*Defaults\h+([^#\n\r]+,\h*)?!use_pty\b' /etc/sudoers* 2>/dev/null)
if [ -n "$NORESULT" ]; then
    echo " - FAIL: Defaults !use_pty is set (should not be):"
    echo "   $NORESULT"
fi
