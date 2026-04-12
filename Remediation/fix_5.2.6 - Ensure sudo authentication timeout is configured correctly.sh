#!/usr/bin/env bash
# CIS 5.2.6 - Ensure sudo authentication timeout is configured correctly (Remediation)
echo "=== CIS 5.2.6 - Configuring sudo authentication timeout ==="

# Check if timestamp_timeout is already set and greater than 15
EXISTING=$(grep -roPn "timestamp_timeout=[0-9]*" /etc/sudoers* 2>/dev/null)
if [ -n "$EXISTING" ]; then
    echo " - INFO: Existing timeout found: $EXISTING"
    echo " - Use visudo -f <file> to edit the relevant file and set:"
    echo "   Defaults timestamp_timeout=15"
else
    if ! grep -rPiq "timestamp_timeout=" /etc/sudoers* 2>/dev/null; then
        echo "Defaults timestamp_timeout=15" >> /etc/sudoers.d/00-cis-defaults
        echo " - Added 'Defaults timestamp_timeout=15' to /etc/sudoers.d/00-cis-defaults"
    fi
fi
