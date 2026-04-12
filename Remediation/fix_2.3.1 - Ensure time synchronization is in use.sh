#!/usr/bin/env bash
# CIS 2.3.1 - Ensure time synchronization is in use (chrony)
# Remediation script for RHEL 9 / CIS Benchmark

PKG="chrony"

# Check if chrony is installed
if rpm -q "$PKG" &>/dev/null; then
    echo " - Package $PKG is already installed - no changes needed"
    echo " - chrony version: $(rpm -q "$PKG")"
else
    echo " - Package $PKG is not installed - installing..."
    dnf install -y "$PKG"
    if rpm -q "$PKG" &>/dev/null; then
        echo " - $PKG installed successfully"
        # Enable and start chrony
        systemctl enable chronyd 2>/dev/null || true
        systemctl start chronyd 2>/dev/null || true
        echo " - chronyd service enabled and started"
    else
        echo " - ERROR: Failed to install $PKG"
        exit 1
    fi
fi

echo " - Done. Time synchronization (chrony) remediation complete."
echo " - NOTE: On systems where host based time synchronization is available, consult your documentation."
