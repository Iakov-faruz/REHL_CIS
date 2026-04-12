#!/usr/bin/env bash
# CIS 2.2.2 - Ensure ldap client is not installed (Audit - Level 2)
PKG="openldap-clients"
echo " - NOTE: Level 2 recommendation"
rpm -q "$PKG" &>/dev/null && echo " - FAIL: $PKG is installed" && rpm -q "$PKG" || echo " - PASS: $PKG is not installed"
