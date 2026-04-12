#!/usr/bin/env bash
# CIS 2.2.1 - Ensure ftp client is not installed (Audit)
PKG="ftp"
rpm -q "$PKG" &>/dev/null && echo " - FAIL: $PKG is installed" && rpm -q "$PKG" || echo " - PASS: $PKG is not installed"
