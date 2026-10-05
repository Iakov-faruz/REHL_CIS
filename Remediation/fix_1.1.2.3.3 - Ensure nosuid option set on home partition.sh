#!/usr/bin/env bash
# IF: a separate partition exists for /home.
# Edit /etc/fstab and add nosuid to the fourth field (mounting options) for /home.
# Example:
#   <device> /home <fstype> defaults,rw,nosuid,nodev,noexec,relatime 0 0

#!/usr/bin/env bash
# CIS Benchmark Remediation: 1.1.2.3.3 Ensure nosuid option set on /home partition
# Exit Codes: 0 = PASS, 1 = FAIL

set -euo pipefail

FSTAB="/etc/fstab"
MOUNT_POINT="/home"
TMP_FSTAB="${FSTAB}.tmp.$$"

cleanup() { rm -f "$TMP_FSTAB"; }
trap cleanup EXIT

# 1. Check if /home is a separate partition
if ! findmnt -kn "$MOUNT_POINT" >/dev/null 2>&1; then
    echo "PASS: /home is not a separate partition (Not Applicable)"
    exit 0
fi

# 2. Check persistent + runtime
if awk -v mp="$MOUNT_POINT" '$0 !~ /^#/ && $2 == mp && $4 ~ /(^|,)nosuid(,|$)/' "$FSTAB" >/dev/null &&
   findmnt -kn -o OPTIONS "$MOUNT_POINT" | grep -qw nosuid; then
    echo "PASS: nosuid already set on /home"
    exit 0
fi

echo "INFO: nosuid missing — applying remediation..."

# 3. Update fstab
awk -v mp="$MOUNT_POINT" '
BEGIN { found=0; modified=0 }
{
    if ($0 !~ /^#/ && $2 == mp) {
        found=1
        if ($4 !~ /(^|,)nosuid(,|$)/) {
            if ($4 == "" || $4 == "-") $4 = "nosuid"
            else $4 = $4 ",nosuid"
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
    echo "FAIL: /home entry not found in fstab"
    exit 1
elif [ "$awk_status" -eq 2 ]; then
    echo "PASS: nosuid already present in fstab"
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
if ! mount -o remount,nosuid "$MOUNT_POINT" 2>/dev/null; then
    echo "FAIL: remount failed"
    exit 1
fi

# 6. Final verification
if findmnt -kn -o OPTIONS "$MOUNT_POINT" | grep -qw nosuid; then
    echo "PASS: nosuid successfully applied"
    exit 0
else
    echo "FAIL: nosuid still not active"
    exit 1
fi
mount -o remount /home
