#!/usr/bin/env bash
# CIS 5.2.2 - Ensure sudo commands use pty (Remediation)
echo "=== CIS 5.2.2 - Configuring sudo use_pty ==="

# Add use_pty if not already set
if ! grep -rPiq '^\h*Defaults\h+([^#\n\r]+,\h*)?use_pty\b' /etc/sudoers* 2>/dev/null; then
    echo "Defaults use_pty" >> /etc/sudoers.d/00-cis-defaults
    echo " - Added 'Defaults use_pty' to /etc/sudoers.d/00-cis-defaults"
else
    echo " - INFO: 'Defaults use_pty' already set"
fi

# Remove !use_pty if present
if grep -rPiq '^\h*Defaults\h+([^#\n\r]+,\h*)?!use_pty\b' /etc/sudoers* 2>/dev/null; then
    sed -ri '/^\h*Defaults\h+([^#\n\r]+,\h*)?!use_pty\b/d' /etc/sudoers /etc/sudoers.d/* 2>/dev/null
    echo " - Removed '!use_pty' entries"
fi
