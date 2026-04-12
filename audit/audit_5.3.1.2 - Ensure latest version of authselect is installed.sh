#!/usr/bin/env bash
# CIS 5.3.1.2 - Ensure latest version of authselect is installed (Audit)

echo "=== CIS 5.3.1.2 - Auditing authselect version ==="
AUTH_VER=$(rpm -q authselect 2>/dev/null)
if [ $? -eq 0 ]; then
    echo " - Installed: $AUTH_VER"
    echo " - Required: authselect-1.2.6-2 or greater"
    echo " - Verify that the installed version meets the minimum requirement"
else
    echo " - FAIL: authselect package is not installed"
fi
