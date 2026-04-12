#!/usr/bin/env bash
# CIS 5.3.1.1 - Ensure latest version of pam is installed (Remediation)
echo "=== CIS 5.3.1.1 - Upgrading pam ==="
dnf upgrade -y pam
echo " - pam upgraded to latest version"
