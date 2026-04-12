#!/usr/bin/env bash
# CIS 5.3.1.2 - Ensure latest version of authselect is installed (Remediation)
echo "=== CIS 5.3.1.2 - Installing/Upgrading authselect ==="
dnf install -y authselect
dnf upgrade -y authselect
echo " - authselect installed/upgraded to latest version"
