#!/usr/bin/env bash
# CIS 2.2.2 - Ensure ldap client is not installed (Level 2)
# Remediation script for RHEL 9 / CIS Benchmark

PKG="openldap-clients"

echo " - NOTE: This is a Level 2 recommendation."
echo " - NOTE: Removing LDAP client will prevent LDAP authentication in your environment."
echo ""

if rpm -q "$PKG" &>/dev/null; then
    echo " - Package $PKG is installed - removing..."
    dnf remove -y "$PKG"
    echo " - $PKG removed"
else
    echo " - Package $PKG is not installed - no changes needed"
fi

echo " - Done. LDAP client removal remediation complete."
