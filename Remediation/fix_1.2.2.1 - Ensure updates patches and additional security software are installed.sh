#!/usr/bin/env bash
# 1.2.2.1 - Ensure updates, patches, and additional security software are installed (Manual)
# Install all available updates:
dnf update

# Verify if reboot is required:
dnf needs-restarting -r
