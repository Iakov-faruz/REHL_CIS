#!/usr/bin/env bash
# CIS 5.2.7 - Ensure access to the su command is restricted (Remediation)
echo "=== CIS 5.2.7 - Restricting su command ==="

GROUP_NAME="sugroup"

# Create empty group if it doesn't exist
if ! getent group "$GROUP_NAME" >/dev/null; then
    groupadd "$GROUP_NAME"
    echo " - Created group '$GROUP_NAME'"
fi

# Add pam_wheel.so to /etc/pam.d/su if not already configured
if ! grep -Piq '^\h*auth\h+(?:required|requisite)\h+pam_wheel\.so\h' /etc/pam.d/su 2>/dev/null; then
    echo "auth required pam_wheel.so use_uid group=$GROUP_NAME" >> /etc/pam.d/su
    echo " - Added pam_wheel.so to /etc/pam.d/su"
else
    echo " - INFO: pam_wheel.so already configured in /etc/pam.d/su"
fi
