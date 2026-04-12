#!/usr/bin/env bash
# CIS 1.6.2 - Ensure system wide crypto policy is not set in sshd configuration
# Remediation script for RHEL 9 / CIS Benchmark

SSHD_SYSCONFIG="/etc/sysconfig/sshd"

# Check if CRYPTO_POLICY is set in /etc/sysconfig/sshd
if grep -Pi '^\h*CRYPTO_POLICY\h*=' "$SSHD_SYSCONFIG" 2>/dev/null; then
    echo " - CRYPTO_POLICY is set in $SSHD_SYSCONFIG - commenting it out..."
    sed -ri "s/^\s*(CRYPTO_POLICY\s*=.*)$/# \1/" "$SSHD_SYSCONFIG"
    echo " - Reloading sshd..."
    systemctl reload sshd
    echo " - Done. CRYPTO_POLICY has been commented out in $SSHD_SYSCONFIG"
else
    echo " - CRYPTO_POLICY is NOT set in $SSHD_SYSCONFIG - no changes needed"
fi

echo " - Done. sshd crypto policy override remediation complete."
