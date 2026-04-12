#!/usr/bin/env bash
# CIS 1.8.1 - Ensure GNOME Display Manager is removed (Level 2 - Server)
# Remediation script for RHEL 9 / CIS Benchmark

# Check if gdm is installed
if rpm -q gdm &>/dev/null; then
    echo " - GDM package is installed - removing..."
    dnf remove -y gdm
    echo " - GDM package removed"
else
    echo " - GDM package is not installed - no changes needed"
fi

echo " - Done. GDM removal remediation complete."
echo " - NOTE: This is a Level 2 - Server recommendation."
echo " - NOTE: Removing GDM removes the Graphical User Interface from the system."
