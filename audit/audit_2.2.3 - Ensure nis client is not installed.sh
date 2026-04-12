#!/usr/bin/env bash
# CIS 2.2.3 - Ensure nis client is not installed (Audit)
PKG="ypbind"
rpm -q "$PKG" &>/dev/null && echo " - FAIL: $PKG is installed" && rpm -q "$PKG" || echo " - PASS: $PKG is not installed"
