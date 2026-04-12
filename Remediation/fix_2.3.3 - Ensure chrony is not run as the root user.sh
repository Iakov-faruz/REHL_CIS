#!/usr/bin/env bash
# CIS 2.3.3 - Ensure chrony is not run as the root user
# Remediation script for RHEL 9 / CIS Benchmark

CHRONY_SYSCONFIG="/etc/sysconfig/chronyd"

# Check if chrony is installed
if ! rpm -q chrony &>/dev/null; then
    echo " - chrony is not installed. Please run fix_2.3.1 first."
    exit 1
fi

# Check if chrony is configured to run as root
if grep -Psi -- '^\h*OPTIONS=\h*"?\h*([^#\n\r]+\h+)?-u\h+root\b' "$CHRONY_SYSCONFIG" 2>/dev/null; then
    echo " - chrony is configured to run as root - fixing..."

    # Remove -u root from OPTIONS
    sed -i 's/\s*-u\s*root\b//g' "$CHRONY_SYSCONFIG"
    echo " - Removed -u root from OPTIONS in $CHRONY_SYSCONFIG"

    # Verify fix
    if grep -Psi -- '^\h*OPTIONS=\h*"?\h*([^#\n\r]+\h+)?-u\h+root\b' "$CHRONY_SYSCONFIG" 2>/dev/null; then
        echo " - WARNING: -u root may still be present, please check $CHRONY_SYSCONFIG manually"
    else
        echo " - -u root successfully removed from OPTIONS"
    fi

    # Reload chronyd configuration
    systemctl reload-or-restart chronyd 2>/dev/null && echo " - chronyd reloaded" || true
else
    echo " - chrony is NOT configured to run as root - no changes needed"
    if [ -f "$CHRONY_SYSCONFIG" ]; then
        echo " - Current OPTIONS: $(grep -i 'OPTIONS=' $CHRONY_SYSCONFIG 2>/dev/null || echo 'not set')"
    fi
fi

echo " - Done. chrony user configuration remediation complete."
