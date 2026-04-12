#!/usr/bin/env bash
# CIS 2.3.3 - Ensure chrony is not run as the root user (Audit)

if ! rpm -q chrony &>/dev/null; then
    echo " - N/A: chrony is not installed"
    exit 0
fi

CHRONY_SYSCONFIG="/etc/sysconfig/chronyd"

echo "=== Checking chrony user configuration ==="
if grep -Psi -- '^\h*OPTIONS=\h*"?\h*([^#\n\r]+\h+)?-u\h+root\b' "$CHRONY_SYSCONFIG" 2>/dev/null; then
    echo " - FAIL: chronyd is configured to run as root (-u root is set in OPTIONS)"
else
    echo " - PASS: chronyd is NOT configured to run as root"
    if [ -f "$CHRONY_SYSCONFIG" ]; then
        echo " - Current OPTIONS: $(grep -i 'OPTIONS=' "$CHRONY_SYSCONFIG" 2>/dev/null || echo 'not set')"
    fi
fi
