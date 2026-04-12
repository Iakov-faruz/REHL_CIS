#!/usr/bin/env bash
# CIS Benchmark: 6.1.3 - Ensure cryptographic mechanisms protect integrity of audit tools
# Level: 1 - Server | 1 - Workstation

echo "=================================================================="
echo " CIS 6.1.3 - Configure AIDE Crypto for Audit Tools"
echo "=================================================================="

AUDIT_TOOLS=(auditctl auditd ausearch aureport autrace augenrules)
AIDE_CONF="/etc/aide.conf"

if [ ! -f "$AIDE_CONF" ]; then
    echo "[ERROR] $AIDE_CONF not found. Install AIDE first (6.1.1)."
    exit 1
fi

# Determine the actual sbin path (could be /usr/sbin or /sbin)
SBIN_PATH=$(readlink -f /sbin)
echo "[INFO] Using sbin path: $SBIN_PATH"

# Remove any existing audit tool lines to avoid duplicates
for tool in "${AUDIT_TOOLS[@]}"; do
    tool_path="$SBIN_PATH/$tool"
    # Remove existing entry if present
    sed -i "\|^[[:space:]]*${tool_path}[[:space:]]|d" "$AIDE_CONF"
done

# Append fresh audit tool entries
{
    echo ""
    echo "# Audit Tools - CIS 6.1.3"
    for tool in "${AUDIT_TOOLS[@]}"; do
        tool_path="$SBIN_PATH/$tool"
        if [ -f "$tool_path" ]; then
            echo "${tool_path} p+i+n+u+g+s+b+acl+xattrs+sha512"
        fi
    done
} >> "$AIDE_CONF"

echo "[DONE] Audit tool entries added to $AIDE_CONF"
echo "[INFO] Re-initialize AIDE database to apply: aide --init && mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz"
