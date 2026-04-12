#!/usr/bin/env bash
# CIS 1.6.2 - Ensure system wide crypto policy is not set in sshd configuration (Audit)

if grep -Pi '^\h*CRYPTO_POLICY\h*=' /etc/sysconfig/sshd 2>/dev/null; then
    echo " - FAIL: CRYPTO_POLICY is explicitly set in /etc/sysconfig/sshd (should be commented out)"
else
    echo " - PASS: CRYPTO_POLICY is NOT explicitly set in /etc/sysconfig/sshd"
fi
