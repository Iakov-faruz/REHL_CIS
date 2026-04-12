#!/usr/bin/env bash
# CIS Benchmark: 7.1.x - Fix System File Permissions
# Level: 1

echo "=============================================="
echo " CIS 7.1.x - Fix System File Permissions"
echo "=============================================="

# 7.1.1 - /etc/passwd
echo "[INFO] 7.1.1: Fixing /etc/passwd..."
chmod u-x,go-wx /etc/passwd
chown root:root /etc/passwd

# 7.1.2 - /etc/passwd-
echo "[INFO] 7.1.2: Fixing /etc/passwd-..."
[ -e /etc/passwd- ] && chmod u-x,go-wx /etc/passwd- && chown root:root /etc/passwd-

# 7.1.3 - /etc/group
echo "[INFO] 7.1.3: Fixing /etc/group..."
chmod u-x,go-wx /etc/group
chown root:root /etc/group

# 7.1.4 - /etc/group-
echo "[INFO] 7.1.4: Fixing /etc/group-..."
[ -e /etc/group- ] && chmod u-x,go-wx /etc/group- && chown root:root /etc/group-

# 7.1.5 - /etc/shadow
echo "[INFO] 7.1.5: Fixing /etc/shadow..."
chown root:root /etc/shadow
chmod 0000 /etc/shadow

# 7.1.6 - /etc/shadow-
echo "[INFO] 7.1.6: Fixing /etc/shadow-..."
[ -e /etc/shadow- ] && chown root:root /etc/shadow- && chmod 0000 /etc/shadow-

# 7.1.7 - /etc/gshadow
echo "[INFO] 7.1.7: Fixing /etc/gshadow..."
chown root:root /etc/gshadow
chmod 0000 /etc/gshadow

# 7.1.8 - /etc/gshadow-
echo "[INFO] 7.1.8: Fixing /etc/gshadow-..."
[ -e /etc/gshadow- ] && chown root:root /etc/gshadow- && chmod 0000 /etc/gshadow-

# 7.1.9 - /etc/shells
echo "[INFO] 7.1.9: Fixing /etc/shells..."
chmod u-x,go-wx /etc/shells
chown root:root /etc/shells

# 7.1.10 - /etc/security/opasswd
echo "[INFO] 7.1.10: Fixing /etc/security/opasswd..."
[ -e /etc/security/opasswd ] && chmod u-x,go-rwx /etc/security/opasswd && chown root:root /etc/security/opasswd
[ -e /etc/security/opasswd.old ] && chmod u-x,go-rwx /etc/security/opasswd.old && chown root:root /etc/security/opasswd.old

# 7.1.11 - World writable files and directories
echo "[INFO] 7.1.11: Fixing world writable files and directories..."
{
    l_smask='01000'
    a_path=(! -path "/run/user/*" -a ! -path "/proc/*" -a ! -path "*/containerd/*" -a ! -path "*/kubelet/pods/*" -a ! -path "/sys/*" -a ! -path "/snap/*")
    while IFS= read -r l_mount; do
        while IFS= read -r -d $'\0' l_file; do
            if [ -e "$l_file" ]; then
                l_mode="$(stat -Lc '%#a' "$l_file")"
                if [ -f "$l_file" ]; then
                    chmod o-w "$l_file"
                fi
                if [ -d "$l_file" ]; then
                    if [ ! $(( $l_mode & $l_smask )) -gt 0 ]; then
                        chmod a+t "$l_file"
                    fi
                fi
            fi
        done < <(find "$l_mount" -xdev \( "${a_path[@]}" \) \( -type f -o -type d \) -perm -0002 -print0 2>/dev/null)
    done < <(findmnt -Dkerno fstype,target | awk '($1 !~ /^\s*(nfs|proc|smb|vfat|iso9660|efivarfs|selinuxfs)/ && $2 !~ /^(\/run\/user\/|\/tmp|\/var\/tmp)/){print $2}')
}

echo "[DONE] System file permissions fixed."
