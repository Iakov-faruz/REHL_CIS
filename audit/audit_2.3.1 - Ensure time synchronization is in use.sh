#!/usr/bin/env bash
# CIS 2.3.1 - Ensure time synchronization is in use (Audit)
PKG="chrony"
if rpm -q "$PKG" &>/dev/null; then
    echo " - PASS: $PKG is installed"
    rpm -q "$PKG"
    echo " - chronyd service status:"
    systemctl is-enabled chronyd 2>/dev/null && systemctl is-active chronyd 2>/dev/null || true
else
    echo " - FAIL: $PKG is NOT installed"
    echo " - NOTE: On systems using host-based time sync, this may be acceptable per site policy"
fi
