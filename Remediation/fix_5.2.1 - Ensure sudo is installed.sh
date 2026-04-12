#!/usr/bin/env bash
# CIS 5.2.1 - Ensure sudo is installed (Remediation)
echo "=== CIS 5.2.1 - Installing sudo ==="
dnf install -y sudo
echo " - sudo installed"
