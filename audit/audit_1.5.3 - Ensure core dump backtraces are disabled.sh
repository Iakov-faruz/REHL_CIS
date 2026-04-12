#!/usr/bin/env bash
# CIS 1.5.3 - Ensure core dump backtraces are disabled (Audit)
CONF_FILE="/etc/systemd/coredump.conf.d/60-coredump.conf"

if grep -Psq '^\h*ProcessSizeMax\h*=\h*0\b' "$CONF_FILE" 2>/dev/null; then
    echo " - PASS: ProcessSizeMax=0 is set in $CONF_FILE"
else
    echo " - FAIL: ProcessSizeMax=0 is NOT set in $CONF_FILE (or file does not exist)"
    if [ -d "/etc/systemd/coredump.conf.d" ]; then
        echo " - INFO: Directory /etc/systemd/coredump.conf.d exists"
        echo " - INFO: Current coredump.conf.d contents:"
        grep -Prs 'ProcessSizeMax' /etc/systemd/coredump.conf.d/ 2>/dev/null || echo "   (not found)"
    else
        echo " - INFO: Directory /etc/systemd/coredump.conf.d does NOT exist"
    fi
fi
