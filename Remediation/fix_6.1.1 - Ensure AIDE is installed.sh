#!/usr/bin/env bash
# CIS Benchmark: 6.1.1 - Ensure AIDE is installed
# Level: 1 - Server | 1 - Workstation

echo "=============================="
echo " CIS 6.1.1 - Install AIDE"
echo "=============================="

if ! rpm -q aide &>/dev/null; then
    echo "[INFO] Installing AIDE..."
    dnf install -y aide
else
    echo "[INFO] AIDE already installed: $(rpm -q aide)"
fi

# Initialize aide database if not present
if [ ! -f /var/lib/aide/aide.db.gz ]; then
    echo "[INFO] Initializing AIDE database..."
    aide --init
    mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
    echo "[DONE] AIDE database initialized."
else
    echo "[INFO] AIDE database already exists."
fi

echo "[DONE] CIS 6.1.1 remediation complete."
