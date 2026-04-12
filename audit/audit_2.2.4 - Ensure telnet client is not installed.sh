#!/usr/bin/env bash
# CIS 2.2.4 - Ensure telnet client is not installed (Audit)
PKG="telnet"
rpm -q "$PKG" &>/dev/null && echo " - FAIL: $PKG is installed" && rpm -q "$PKG" || echo " - PASS: $PKG is not installed"
