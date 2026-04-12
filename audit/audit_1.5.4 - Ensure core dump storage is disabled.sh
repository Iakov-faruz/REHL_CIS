#!/usr/bin/env bash
# CIS 1.5.4 - Ensure core dump storage is disabled (Audit)
CONF_FILE="/etc/systemd/coredump.conf.d/60-coredump.conf"

if grep -Psq '^\h*Storage\h*=\h*none\b' "$CONF_FILE" 2>/dev/null; then
    echo " - PASS: Storage=none is set in $CONF_FILE"
else
    echo " - FAIL: Storage=none is NOT set in $CONF_FILE (or file does not exist)"
    if [ -d "/etc/systemd/coredump.conf.d" ]; then
        echo " - INFO: Current Storage settings in coredump.conf.d:"
        grep -Prs 'Storage' /etc/systemd/coredump.conf.d/ 2>/dev/null || echo "   (not found)"
    else
        echo " - INFO: Directory /etc/systemd/coredump.conf.d does NOT exist"
    fi
fi
