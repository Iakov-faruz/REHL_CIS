#!/usr/bin/env bash
# CIS 5.3.1.1 - Ensure latest version of pam is installed (Audit)

echo "=== CIS 5.3.1.1 - Auditing pam version ==="
PAM_VER=$(rpm -q pam 2>/dev/null)
if [ $? -eq 0 ]; then
    echo " - Installed: $PAM_VER"
    echo " - Required: pam-1.5.1-19 or greater"
    echo " - Verify that the installed version meets the minimum requirement"
else
    echo " - FAIL: pam package is not installed"
fi
