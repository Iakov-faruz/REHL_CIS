#!/usr/bin/env bash
# CIS Benchmark: 6.3.1.1 - Ensure auditd packages are installed
# CIS Benchmark: 6.3.1.2 - Ensure auditing for processes that start prior to auditd is enabled
# Level: 2 - Server | 2 - Workstation

echo "=============================================="
echo " CIS 6.3.1.1 - Install auditd packages"
echo "=============================================="

# 6.3.1.1 - Install audit and audit-libs
if ! rpm -q audit &>/dev/null || ! rpm -q audit-libs &>/dev/null; then
    echo "[INFO] Installing audit and audit-libs..."
    dnf install -y audit audit-libs
else
    echo "[INFO] audit and audit-libs already installed."
fi

echo ""
echo "=============================================="
echo " CIS 6.3.1.2 - Enable audit=1 in Grub"
echo "=============================================="

# 6.3.1.2 - Add audit=1 to kernel command line via grubby
echo "[INFO] Adding audit=1 to all kernel entries via grubby..."
grubby --update-kernel ALL --args 'audit=1'

# Also update /etc/default/grub for persistence across kernel updates
GRUB_FILE="/etc/default/grub"
if grep -q 'GRUB_CMDLINE_LINUX=' "$GRUB_FILE"; then
    # Add audit=1 if it's not already present
    if ! grep -Pq 'GRUB_CMDLINE_LINUX=.*\baudit=1\b' "$GRUB_FILE"; then
        echo "[INFO] Adding audit=1 to GRUB_CMDLINE_LINUX in $GRUB_FILE..."
        sed -i 's/\(GRUB_CMDLINE_LINUX="[^"]*\)"/\1 audit=1"/' "$GRUB_FILE"
    else
        echo "[INFO] audit=1 already present in $GRUB_FILE"
    fi
else
    echo "[INFO] Adding GRUB_CMDLINE_LINUX with audit=1 to $GRUB_FILE..."
    echo 'GRUB_CMDLINE_LINUX="audit=1"' >> "$GRUB_FILE"
fi

echo "[INFO] Verifying grubby configuration..."
grubby --info=ALL | grep -o 'audit=1' | head -1 && echo "[DONE] audit=1 confirmed in grub." || echo "[WARN] audit=1 not confirmed. Verify manually."
echo ""
echo "[NOTE] A system reboot is required for audit=1 to take effect on running processes."
