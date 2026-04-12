#!/usr/bin/env bash
# CIS Benchmark: 6.2.4.1 - Ensure access to all logfiles has been configured
# Level: 1 - Server | 1 - Workstation

PASS=0
FAIL=0

echo "======================================================="
echo " CIS 6.2.4.1 - Log File Permissions and Ownership"
echo "======================================================="

l_uidmin="$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"

check_logfile() {
    local fname="$1" mode="$2" user="$3" uid="$4" group="$5" gid="$6"
    local bname perm_mask maxperm allowed_user allowed_group result=PASS

    bname="$(basename "$fname")"

    case "$bname" in
        lastlog|lastlog.*|wtmp|wtmp.*|wtmp-*|btmp|btmp.*|btmp-*|README)
            perm_mask=0113; allowed_user="root"; allowed_group="(root|utmp)" ;;
        secure|auth.log|syslog|messages)
            perm_mask=0137; allowed_user="(root|syslog)"; allowed_group="(root|adm)" ;;
        SSSD|sssd)
            perm_mask=0117; allowed_user="(root|SSSD)"; allowed_group="(root|SSSD)" ;;
        gdm|gdm3)
            perm_mask=0117; allowed_user="root"; allowed_group="(root|gdm|gdm3)" ;;
        *.journal|*.journal~)
            perm_mask=0137; allowed_user="root"; allowed_group="(root|systemd-journal)" ;;
        *)
            perm_mask=0137; allowed_user="(root|syslog)"; allowed_group="(root|adm)" ;;
    esac

    maxperm=$(printf '%o' $(( 0777 & ~perm_mask )))
    mode_dec=$(( 8#$mode ))

    if (( ( 8#$mode & perm_mask ) > 0 )); then
        echo "[FAIL] $fname - mode $mode exceeds $maxperm"
        result=FAIL
    fi
    if [[ ! "$user" =~ $allowed_user ]]; then
        echo "[FAIL] $fname - owned by '$user', expected '$allowed_user'"
        result=FAIL
    fi
    if [[ ! "$group" =~ $allowed_group ]]; then
        echo "[FAIL] $fname - group '$group', expected '$allowed_group'"
        result=FAIL
    fi

    if [[ "$result" == "PASS" ]]; then
        echo "[PASS] $fname (mode=$mode, user=$user, group=$group)"
        ((PASS++))
    else
        ((FAIL++))
    fi
}

while IFS= read -r -d $'\0' l_file; do
    [ -e "$l_file" ] || continue
    read -r l_fname l_mode l_user l_uid l_group l_gid <<< \
        "$(stat -Lc '%n %#a %U %u %G %g' "$l_file" | tr ' ' '\n' | paste - - - - - -)"
    check_logfile "$l_fname" "$l_mode" "$l_user" "$l_uid" "$l_group" "$l_gid"
done < <(find -L /var/log -type f \( -perm /0137 -o ! -user root -o ! -group root \) -print0)

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
