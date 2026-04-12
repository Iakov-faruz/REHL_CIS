#!/usr/bin/env bash
# CIS Benchmark: 6.2.4.1 - Ensure access to all logfiles has been configured
# Level: 1 - Server | 1 - Workstation

echo "======================================================="
echo " CIS 6.2.4.1 - Fix Log File Permissions and Ownership"
echo "======================================================="

fix_logfile() {
    local fname="$1" mode="$2" user="$3" uid="$4" group="$5" gid="$6"
    local bname perm_mask allowed_user allowed_group rperms fixed=false

    bname="$(basename "$fname")"

    case "$bname" in
        lastlog|lastlog.*|wtmp|wtmp.*|wtmp-*|btmp|btmp.*|btmp-*|README)
            perm_mask=0113; rperms="ug-x,o-wx"; allowed_user="root"; allowed_group="(root|utmp)" ;;
        secure|auth.log|syslog|messages)
            perm_mask=0137; rperms="u-x,g-wx,o-rwx"; allowed_user="(root|syslog)"; allowed_group="(root|adm)" ;;
        SSSD|sssd)
            perm_mask=0117; rperms="ug-x,o-rwx"; allowed_user="(root|SSSD)"; allowed_group="(root|SSSD)" ;;
        gdm|gdm3)
            perm_mask=0117; rperms="ug-x,o-rwx"; allowed_user="root"; allowed_group="(root|gdm|gdm3)" ;;
        *.journal|*.journal~)
            perm_mask=0137; rperms="u-x,g-wx,o-rwx"; allowed_user="root"; allowed_group="(root|systemd-journal)" ;;
        *)
            perm_mask=0137; rperms="u-x,g-wx,o-rwx"; allowed_user="(root|syslog)"; allowed_group="(root|adm)" ;;
    esac

    if (( ( 8#$mode & perm_mask ) > 0 )); then
        echo "[FIX] $fname: setting permissions $rperms"
        chmod "$rperms" "$fname"
        fixed=true
    fi
    if [[ ! "$user" =~ $allowed_user ]]; then
        echo "[FIX] $fname: changing owner to root"
        chown root "$fname"
        fixed=true
    fi
    if [[ ! "$group" =~ $allowed_group ]]; then
        echo "[FIX] $fname: changing group to root"
        chgrp root "$fname"
        fixed=true
    fi

    $fixed || echo "[OK]  $fname"
}

while IFS= read -r -d $'\0' l_file; do
    [ -e "$l_file" ] || continue
    read -r l_fname l_mode l_user l_uid l_group l_gid <<< \
        "$(stat -Lc '%n %#a %U %u %G %g' "$l_file" | tr ' ' '\n' | paste - - - - - -)"
    fix_logfile "$l_fname" "$l_mode" "$l_user" "$l_uid" "$l_group" "$l_gid"
done < <(find -L /var/log -type f \( -perm /0137 -o ! -user root -o ! -group root \) -print0)

echo "[DONE] Log file permissions and ownership fixed."
