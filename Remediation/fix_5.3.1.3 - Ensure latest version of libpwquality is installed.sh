#!/usr/bin/env bash
# CIS 5.3.1.3 - Ensure latest version of libpwquality is installed (Remediation)
echo "=== CIS 5.3.1.3 - Installing/Upgrading libpwquality ==="
dnf install -y libpwquality
dnf upgrade -y libpwquality
echo " - libpwquality installed/upgraded to latest version"
