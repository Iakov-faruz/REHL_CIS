#!/usr/bin/env bash
# IF: a separate partition exists for /home.
# Edit /etc/fstab and add nodev to the fourth field (mounting options) for /home.
# Example:
#   <device> /home <fstype> defaults,rw,nosuid,nodev,noexec,relatime 0 0
#!/usr/bin/env bash
# CIS Benchmark Remediation: 1.1.2.3.2 Ensure nodev option set on /home partition
# Level 1 - Server / Level 1 - Workstation
# Exit Codes: 0 = PASS (already compliant or successfully remediated)
#             1 = FAIL (error or verification failed)

FSTAB="/etc/fstab"
MOUNT_POINT="/home"
TMP_FSTAB="${FSTAB}.tmp.$$"

cleanup() { rm -f "$TMP_FSTAB"; }
trap cleanup EXIT

# 1. אם /home אינו partition נפרד — Not Applicable (CIS)
if ! findmnt -kn "$MOUNT_POINT" >/dev/null 2>&1; then
    echo "PASS: /home is not a separate partition (Not Applicable)"
    exit 0
fi

# 2. בדיקה: האם nodev כבר קיים ב-runtime וב-fstab?
if findmnt -kn -o OPTIONS "$MOUNT_POINT" | grep -qw nodev; then
    if awk -v mp="$MOUNT_POINT" '
        $0 !~ /^#/ && $2 == mp && $4 ~ /(^|,)nodev(,|$)/ { found=1 }
        END { exit !found }
    ' "$FSTAB"; then
        echo "PASS: nodev already set on /home (runtime + persistent)"
        exit 0
    fi
fi

echo "INFO: nodev missing — starting remediation..."

# 3. Remediation — עדכון fstab
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
' "$FSTAB" > "$TMP_FSTAB"

awk_status=$?

if [ "$awk_status" -eq 1 ]; then
    echo "FAIL: /home entry not found in fstab"
    exit 1
elif [ "$awk_status" -eq 2 ]; then
    echo "PASS: nodev already present in fstab (no change needed)"
    exit 0
fi

# 4. החלה של השינויים
if [ ! -s "$TMP_FSTAB" ]; then
    echo "FAIL: temporary fstab file is empty"
    exit 1
fi

cp -f "$TMP_FSTAB" "$FSTAB"
chmod 644 "$FSTAB"

# 5. Remount עם nodev מפורש
if ! mount -o remount,nodev "$MOUNT_POINT" 2>/dev/null; then
    echo "FAIL: remount with nodev failed"
    exit 1
fi

mount -o remount /home

# 6. אימות סופי
if findmnt -kn -o OPTIONS "$MOUNT_POINT" | grep -qw nodev; then
    echo "PASS: nodev successfully applied to /home"
    exit 0
else
    echo "FAIL: nodev still not active after remediation"
    exit 1
fi
