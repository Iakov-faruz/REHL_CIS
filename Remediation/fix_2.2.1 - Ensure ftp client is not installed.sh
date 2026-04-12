#!/usr/bin/env bash
# CIS 2.2.1 - Ensure ftp client is not installed
# Remediation script for RHEL 9 / CIS Benchmark

PKG="ftp"

if rpm -q "$PKG" &>/dev/null; then
    echo " - Package $PKG is installed - removing..."
    dnf remove -y "$PKG"
    echo " - $PKG removed"
else
    echo " - Package $PKG is not installed - no changes needed"
fi

echo " - Done. FTP client removal remediation complete."
