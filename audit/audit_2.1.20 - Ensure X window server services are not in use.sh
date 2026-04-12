#!/usr/bin/env bash
# CIS 2.1.20 - Ensure X window server services are not in use (Audit - Level 2 Server)
PKG="xorg-x11-server-common"
echo " - NOTE: This is a Level 2 - Server recommendation"
if ! rpm -q "$PKG" &>/dev/null; then
    echo " - PASS: $PKG is not installed"
else
    echo " - FAIL: $PKG is installed (should not be on servers)"
    rpm -q "$PKG"
fi
