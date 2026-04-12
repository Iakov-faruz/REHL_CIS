#!/usr/bin/env bash
# CIS 5.2.3 - Ensure sudo log file exists (Audit)

echo "=== CIS 5.2.3 - Auditing sudo log file ==="
RESULT=$(grep -rPsi "^\h*Defaults\h+([^#]+,\h*)?logfile\h*=\h*(\"|\')?\\H+(\"|\')?(,\h*\\H+\h*)*\h*(#.*)?$" /etc/sudoers* 2>/dev/null)
if [ -n "$RESULT" ]; then
    echo " - PASS: sudo logfile is configured:"
    echo "   $RESULT"
else
    echo " - FAIL: sudo logfile is NOT configured in /etc/sudoers*"
fi
