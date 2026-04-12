#!/usr/bin/env bash
# 1.2.2.1 - Ensure updates, patches, and additional security software are installed (Manual)
# Check for available updates:
dnf check-update

# Check if reboot is required:
dnf needs-restarting -r
