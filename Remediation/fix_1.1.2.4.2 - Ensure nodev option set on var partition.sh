#!/usr/bin/env bash
# CIS Benchmark Remediation: Ensure nodev option set on /var partition
# Edit /etc/fstab and add nodev to the fourth field (mounting options) for /var.
# Example:
#   <device> /var <fstype> defaults,rw,nosuid,nodev,noexec,relatime 0 0
#   # Exit Codes: 0 = PASS, 1 = FAIL


set -euo pipefail

FSTAB="/etc/fstab"
MOUNT_POINT="/var"
TMP_FSTAB="${FSTAB}.tmp.$$"

cleanup() { rm -f "$TMP_FSTAB"; }
trap cleanup EXIT

# 1. Check if /var is a separate partition
if ! findmnt -kn "$MOUNT_POINT" >/dev/null 2>&1; then
    echo "PASS: /var is not a separate partition (Not Applicable)"
    exit 0
fi

# 2. Check persistent + runtime
if awk -v mp="$MOUNT_POINT" '$0 !~ /^#/ && $2 == mp && $4 ~ /(^|,)nodev(,|$)/' "$FSTAB" >/dev/null &&
    findmnt -kn -o OPTIONS "$MOUNT_POINT" | grep -qw nodev; then
    echo "PASS: nodev already set on /var"
    exit 0
fi

echo "INFO: nodev missing — applying remediation..."

# 3. Update fstab
awk -v mp="$MOUNT_POINT" '
BEGIN { found=0; modified=0 }
{
    if ($0 !~ /^#/ && $2 == mp) {
        found=1
        if ($4 !~ /(^|,)nodev(,|$)/) {
            if ($4 == "" || $4 == "-") $4 = "nodev"
            else $4 = $4 ",nodev"
            modified=1
        }
    }
    print
}
END {
    if (!found) exit 1
    if (!modified) exit 2
}
' "$FSTAB" > "$TMP_FSTAB" || true

awk_status=$?

if [ "$awk_status" -eq 1 ]; then
    echo "FAIL: /var entry not found in fstab"
    exit 1
elif [ "$awk_status" -eq 2 ]; then
    echo "PASS: nodev already present in fstab"
    exit 0
fi

# 4. Apply changes
if [ ! -s "$TMP_FSTAB" ]; then
    echo "FAIL: temporary fstab file empty"
    exit 1
fi

cp -f "$TMP_FSTAB" "$FSTAB"
chmod 644 "$FSTAB"

# 5. Remount
if ! mount -o remount,nodev "$MOUNT_POINT" 2>/dev/null; then
    echo "FAIL: remount failed"
    exit 1
fi

# 6. Final verification
if findmnt -kn -o OPTIONS "$MOUNT_POINT" | grep -qw nodev; then
    echo "PASS: nodev successfully applied"
    exit 0
else
    echo "FAIL: nodev still not active"
    exit 1
fi
