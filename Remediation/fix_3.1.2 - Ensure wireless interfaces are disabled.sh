#!/usr/bin/env bash
# CIS 3.1.2 - Ensure wireless interfaces are disabled (Remediation)
echo "=== CIS 3.1.2 - Disabling wireless interfaces ==="
if command -v nmcli >/dev/null 2>&1; then
    nmcli radio wifi off
    echo " - Disabled wifi via nmcli"
fi

# We can also unload modules if detecting any wireless drivers loaded...
# For a blanket remediation based on the CIS benchmark, typically we make sure they are administratively down or nmcli radio wifi off.
echo " - Review any custom wireless drivers. If nmcli is not used, manually configure interfaces to be down."
