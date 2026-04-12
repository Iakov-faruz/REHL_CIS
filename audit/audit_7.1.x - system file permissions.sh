#!/usr/bin/env bash
# CIS Benchmark: 7.1.x - System File Permissions Audit
# Covers: 7.1.1-7.1.10 (specific files), 7.1.11 (world writable),
#         7.1.12 (no owner/group), 7.1.13 (SUID/SGID review)
# Level: 1

PASS=0
FAIL=0

echo "=============================================="
echo " CIS 7.1.x - System File Permissions Audit"
echo "=============================================="

# Define files with expected: file mode owner group
declare -A FILE_MODE FILE_OWNER FILE_GROUP

FILE_MODE["/etc/passwd"]="0644"; FILE_OWNER["/etc/passwd"]="root"; FILE_GROUP["/etc/passwd"]="root"
FILE_MODE["/etc/passwd-"]="0644"; FILE_OWNER["/etc/passwd-"]="root"; FILE_GROUP["/etc/passwd-"]="root"
FILE_MODE["/etc/group"]="0644"; FILE_OWNER["/etc/group"]="root"; FILE_GROUP["/etc/group"]="root"
FILE_MODE["/etc/group-"]="0644"; FILE_OWNER["/etc/group-"]="root"; FILE_GROUP["/etc/group-"]="root"
FILE_MODE["/etc/shadow"]="0000"; FILE_OWNER["/etc/shadow"]="root"; FILE_GROUP["/etc/shadow"]="root"
FILE_MODE["/etc/shadow-"]="0000"; FILE_OWNER["/etc/shadow-"]="root"; FILE_GROUP["/etc/shadow-"]="root"
FILE_MODE["/etc/gshadow"]="0000"; FILE_OWNER["/etc/gshadow"]="root"; FILE_GROUP["/etc/gshadow"]="root"
FILE_MODE["/etc/gshadow-"]="0000"; FILE_OWNER["/etc/gshadow-"]="root"; FILE_GROUP["/etc/gshadow-"]="root"
FILE_MODE["/etc/shells"]="0644"; FILE_OWNER["/etc/shells"]="root"; FILE_GROUP["/etc/shells"]="root"

CIS_NUMS=("7.1.1" "7.1.2" "7.1.3" "7.1.4" "7.1.5" "7.1.6" "7.1.7" "7.1.8" "7.1.9")
FILES=("/etc/passwd" "/etc/passwd-" "/etc/group" "/etc/group-" "/etc/shadow" "/etc/shadow-" "/etc/gshadow" "/etc/gshadow-" "/etc/shells")

for i in "${!FILES[@]}"; do
    f="${FILES[$i]}"
    cis="${CIS_NUMS[$i]}"
    expected_mode="${FILE_MODE[$f]}"
    expected_owner="${FILE_OWNER[$f]}"
    expected_group="${FILE_GROUP[$f]}"

    if [ ! -e "$f" ]; then
        echo "[INFO] $cis: $f does not exist (OK if backup file)"
        continue
    fi

    actual=$(stat -Lc '%#a %U %G' "$f")
    read -r a_mode a_owner a_group <<< "$actual"
    result=PASS

    if [ "$a_owner" != "$expected_owner" ]; then
        echo "[FAIL] $cis: $f owner is '$a_owner' (expected '$expected_owner')"
        result=FAIL
    fi
    if [ "$a_group" != "$expected_group" ]; then
        echo "[FAIL] $cis: $f group is '$a_group' (expected '$expected_group')"
        result=FAIL
    fi
    # For shadow files mode should be 0000, for others max 0644
    if [ "$expected_mode" = "0000" ]; then
        if [ "$a_mode" != "0" ] && [ "$a_mode" != "00" ] && [ "$a_mode" != "000" ] && [ "$a_mode" != "0000" ]; then
            echo "[FAIL] $cis: $f mode is $a_mode (expected 0000)"
            result=FAIL
        fi
    else
        # Check no excess beyond 0644
        mode_oct=$(printf '%d' "$a_mode" 2>/dev/null || echo 999)
        if [ $(( $a_mode & 0133 )) -gt 0 ] 2>/dev/null; then
            echo "[FAIL] $cis: $f mode is $a_mode (should be $expected_mode or more restrictive)"
            result=FAIL
        fi
    fi

    if [ "$result" = "PASS" ]; then
        echo "[PASS] $cis: $f ($actual)"
        ((PASS++))
    else
        ((FAIL++))
    fi
done

# 7.1.10 - /etc/security/opasswd
echo ""
echo "--- 7.1.10: /etc/security/opasswd ---"
for ofile in /etc/security/opasswd /etc/security/opasswd.old; do
    if [ -e "$ofile" ]; then
        o_info=$(stat -Lc '%#a %U %G' "$ofile")
        read -r o_mode o_owner o_group <<< "$o_info"
        if [ "$o_owner" = "root" ] && [ "$o_group" = "root" ] && [ $(( $o_mode & 0177 )) -eq 0 ]; then
            echo "[PASS] 7.1.10: $ofile ($o_info)"
            ((PASS++))
        else
            echo "[FAIL] 7.1.10: $ofile ($o_info) - expected mode 0600, root:root"
            ((FAIL++))
        fi
    fi
done

# 7.1.11 - World writable files (summary)
echo ""
echo "--- 7.1.11: World Writable Files ---"
ww_count=$(find / -xdev \( -type f -o -type d \) -perm -0002 \
    ! -path "/proc/*" ! -path "/sys/*" ! -path "/run/user/*" 2>/dev/null | head -20 | wc -l)
if [ "$ww_count" -eq 0 ]; then
    echo "[PASS] No world writable files/directories found"
    ((PASS++))
else
    echo "[REVIEW] 7.1.11: Found $ww_count+ world writable items. Run full scan manually."
    ((FAIL++))
fi

# 7.1.12 - Unowned files (summary)
echo ""
echo "--- 7.1.12: Unowned Files ---"
uo_count=$(find / -xdev \( -type f -o -type d \) \( -nouser -o -nogroup \) \
    ! -path "/proc/*" ! -path "/sys/*" 2>/dev/null | head -20 | wc -l)
if [ "$uo_count" -eq 0 ]; then
    echo "[PASS] No unowned/ungrouped files found"
    ((PASS++))
else
    echo "[REVIEW] 7.1.12: Found $uo_count+ unowned items. Assign proper ownership."
    ((FAIL++))
fi

# 7.1.13 - SUID/SGID (informational)
echo ""
echo "--- 7.1.13: SUID/SGID Files (Review) ---"
suid_count=$(find / -xdev -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null | wc -l)
echo "[INFO] Found $suid_count SUID/SGID files. Review manually for rogue programs."

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
