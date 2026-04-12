#!/usr/bin/env bash
# CIS 7.1.8 - Ensure permissions on /etc/gshadow- are configured
echo "=== CIS 7.1.8 - Fix /etc/gshadow- ==="
[ -e "/etc/gshadow-" ] || { echo "[INFO] /etc/gshadow- does not exist"; exit 0; }
chmod 0000 "/etc/gshadow-"
chown root:root "/etc/gshadow-"
echo "[DONE] /etc/gshadow- permissions fixed"
