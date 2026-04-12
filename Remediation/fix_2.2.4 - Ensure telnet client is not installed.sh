#!/usr/bin/env bash
# CIS 2.2.4 - Ensure telnet client is not installed
# Remediation script for RHEL 9 / CIS Benchmark

PKG="telnet"

if rpm -q "$PKG" &>/dev/null; then
    echo " - Package $PKG is installed - removing..."
    dnf remove -y "$PKG"
    echo " - $PKG removed"
else
    echo " - Package $PKG is not installed - no changes needed"
fi

echo " - Done. Telnet client removal remediation complete."
