#!/usr/bin/env bash
# CIS 2.2.5 - Ensure tftp client is not installed (Audit)
PKG="tftp"
rpm -q "$PKG" &>/dev/null && echo " - FAIL: $PKG is installed" && rpm -q "$PKG" || echo " - PASS: $PKG is not installed"
