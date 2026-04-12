#!/usr/bin/env bash
# CIS 1.8.1 - Ensure GNOME Display Manager is removed (Audit)

if rpm -q gdm &>/dev/null; then
    echo " - FAIL: gdm package is installed. Remove it if this is a server"
    rpm -q gdm
else
    echo " - PASS: gdm package is not installed"
fi
