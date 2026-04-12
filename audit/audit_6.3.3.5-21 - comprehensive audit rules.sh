#!/usr/bin/env bash
# CIS Benchmark: 6.3.3.5-6.3.3.21 - Comprehensive Audit Rules Audit
# Level: 2

PASS=0
FAIL=0

echo "=============================================="
echo " CIS 6.3.3.5-6.3.3.21 - Audit Rules Check"
echo "=============================================="

UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
[ -z "$UID_MIN" ] && { echo "[ERROR] UID_MIN not set"; exit 1; }

check_rule() {
    local desc="$1" pattern="$2"
    local result
    result=$(awk "$pattern" /etc/audit/rules.d/*.rules 2>/dev/null)
    if [ -n "$result" ]; then
        echo "[PASS] $desc"
        ((PASS++))
    else
        echo "[FAIL] $desc - rule missing on disk"
        ((FAIL++))
    fi
}

# 6.3.3.5 - Network environment
echo ""; echo "--- 6.3.3.5: Network Environment ---"
check_rule "sethostname/setdomainname syscalls" '/^ *-a *always,exit/ && / -F *arch=b(32|64)/ && / -S/ && (/sethostname/ || /setdomainname/) && (/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'
for nf in /etc/issue /etc/issue.net /etc/hosts /etc/hostname /etc/sysconfig/network; do
    nf_esc=$(echo "$nf" | sed 's|/|\\/|g')
    check_rule "Watch $nf" "/^ *-w/ && /${nf_esc}/ && / +-p *wa/ && (\/ key= *[!-~]* *\$/||/ -k *[!-~]* *\$/)/"
done

# 6.3.3.6 - Privileged commands
echo ""; echo "--- 6.3.3.6: Privileged Commands ---"
priv_count=0
priv_missing=0
for PARTITION in $(findmnt -n -l -k -it $(awk '/nodev/ { print $2 }' /proc/filesystems | paste -sd,) 2>/dev/null | grep -Pv "noexec|nosuid" | awk '{print $1}'); do
    for PRIV in $(find "$PARTITION" -xdev -perm /6000 -type f 2>/dev/null | head -50); do
        ((priv_count++))
        grep -qr "$PRIV" /etc/audit/rules.d 2>/dev/null || ((priv_missing++))
    done
done
if [ "$priv_missing" -eq 0 ] && [ "$priv_count" -gt 0 ]; then
    echo "[PASS] All $priv_count privileged commands are audited"
    ((PASS++))
else
    echo "[FAIL] $priv_missing of $priv_count privileged commands missing audit rules"
    ((FAIL++))
fi

# 6.3.3.7 - File access attempts
echo ""; echo "--- 6.3.3.7: Unsuccessful File Access ---"
check_rule "File access (b64 EACCES)" "/^ *-a *always,exit/ && / -F *arch=b64/ && / -F *auid>=${UID_MIN}/ && / -F *exit=-EACCES/ && / -S/ && /creat/ && /open/ && /truncate/ && (/ key= *[!-~]* *\$/||/ -k *[!-~]* *\$/)/"
check_rule "File access (b64 EPERM)" "/^ *-a *always,exit/ && / -F *arch=b64/ && / -F *auid>=${UID_MIN}/ && / -F *exit=-EPERM/ && / -S/ && /creat/ && /open/ && /truncate/ && (/ key= *[!-~]* *\$/||/ -k *[!-~]* *\$/)/"

# 6.3.3.8 - User/group identity
echo ""; echo "--- 6.3.3.8: User/Group Modifications ---"
for uf in /etc/group /etc/passwd /etc/gshadow /etc/shadow /etc/security/opasswd /etc/nsswitch.conf /etc/pam.conf /etc/pam.d; do
    uf_esc=$(echo "$uf" | sed 's|/|\\/|g')
    check_rule "Watch $uf" "/^ *-w/ && /${uf_esc}/ && / +-p *wa/ && (\/ key= *[!-~]* *\$/||/ -k *[!-~]* *\$/)/"
done

# 6.3.3.9 - DAC permission modifications
echo ""; echo "--- 6.3.3.9: DAC Permission Modifications ---"
check_rule "chmod/fchmod/fchmodat" "/^ *-a *always,exit/ && / -F *arch=b64/ && / -F *auid>=${UID_MIN}/ && / -S/ && /chmod/ && (/ key= *[!-~]* *\$/||/ -k *[!-~]* *\$/)/"
check_rule "chown/fchown/lchown" "/^ *-a *always,exit/ && / -F *arch=b64/ && / -F *auid>=${UID_MIN}/ && / -S/ && /chown/ && (/ key= *[!-~]* *\$/||/ -k *[!-~]* *\$/)/"
check_rule "xattr operations" "/^ *-a *always,exit/ && / -F *arch=b64/ && / -F *auid>=${UID_MIN}/ && / -S/ && /setxattr/ && (/ key= *[!-~]* *\$/||/ -k *[!-~]* *\$/)/"

# 6.3.3.10 - Mounts
echo ""; echo "--- 6.3.3.10: File System Mounts ---"
check_rule "mount syscall" "/^ *-a *always,exit/ && / -F *arch=b(32|64)/ && / -F *auid>=${UID_MIN}/ && / -S/ && /mount/ && (/ key= *[!-~]* *\$/||/ -k *[!-~]* *\$/)/"

# 6.3.3.11 - Session init
echo ""; echo "--- 6.3.3.11: Session Initiation ---"
for sf in /var/run/utmp /var/log/wtmp /var/log/btmp; do
    sf_esc=$(echo "$sf" | sed 's|/|\\/|g')
    check_rule "Watch $sf" "/^ *-w/ && /${sf_esc}/ && / +-p *wa/ && (\/ key= *[!-~]* *\$/||/ -k *[!-~]* *\$/)/"
done

# 6.3.3.12 - Login/logout
echo ""; echo "--- 6.3.3.12: Login/Logout Events ---"
for lf in /var/log/lastlog /var/run/faillock; do
    lf_esc=$(echo "$lf" | sed 's|/|\\/|g')
    check_rule "Watch $lf" "/^ *-w/ && /${lf_esc}/ && / +-p *wa/ && (\/ key= *[!-~]* *\$/||/ -k *[!-~]* *\$/)/"
done

# 6.3.3.13 - File deletion
echo ""; echo "--- 6.3.3.13: File Deletion ---"
check_rule "unlink/rename syscalls" "/^ *-a *always,exit/ && / -F *arch=b(32|64)/ && / -F *auid>=${UID_MIN}/ && / -S/ && (/unlink/ || /rename/) && (/ key= *[!-~]* *\$/||/ -k *[!-~]* *\$/)/"

# 6.3.3.14 - MAC policy
echo ""; echo "--- 6.3.3.14: MAC Policy ---"
check_rule "SELinux /etc/selinux" '/^ *-w/ && /\/etc\/selinux/ && / +-p *wa/ && (/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)/'
check_rule "SELinux /usr/share/selinux" '/^ *-w/ && /\/usr\/share\/selinux/ && / +-p *wa/ && (/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)/'

# 6.3.3.15-6.3.3.18 - Command auditing (chcon, setfacl, chacl, usermod)
echo ""; echo "--- 6.3.3.15-6.3.3.18: Command Auditing ---"
for cmd_path in /usr/bin/chcon /usr/bin/setfacl /usr/bin/chacl /usr/sbin/usermod; do
    cmd_esc=$(echo "$cmd_path" | sed 's|/|\\/|g')
    cmd_name=$(basename "$cmd_path")
    check_rule "$cmd_name audit" "/^ *-a *always,exit/ && / -F *path=${cmd_esc}/ && / -F *perm=x/ && / -F *auid>=${UID_MIN}/ && (/ key= *[!-~]* *\$/||/ -k *[!-~]* *\$/)/"
done

# 6.3.3.19 - Kernel modules
echo ""; echo "--- 6.3.3.19: Kernel Modules ---"
for km_path in /usr/bin/kmod /usr/sbin/modprobe /usr/sbin/insmod /usr/sbin/rmmod; do
    [ -f "$km_path" ] || continue
    km_esc=$(echo "$km_path" | sed 's|/|\\/|g')
    check_rule "$(basename $km_path)" "/^ *-a *always,exit/ && / -F *path=${km_esc}/ && / -F *perm=x/ && / -F *auid>=${UID_MIN}/ && (/ key= *[!-~]* *\$/||/ -k *[!-~]* *\$/)/"
done
module_disk=$(awk '/^ *-a *always,exit/ && / -F *arch=b64/ && / -S/ && (/init_module/ || /finit_module/ || /delete_module/ || /create_module/ || /query_module/) && (/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules 2>/dev/null)
if [ -n "$module_disk" ]; then
    echo "[PASS] Kernel module syscalls audited"
    ((PASS++))
else
    echo "[FAIL] Kernel module syscalls not audited"
    ((FAIL++))
fi

# 6.3.3.20 - Immutable audit config (-e 2)
echo ""; echo "--- 6.3.3.20: Audit Config Immutable ---"
e2=$(grep -Ph -- '^\h*-e\h+2\b' /etc/audit/rules.d/*.rules 2>/dev/null | tail -1)
if [ -n "$e2" ]; then
    echo "[PASS] -e 2 set (audit rules locked)"
    ((PASS++))
else
    echo "[FAIL] -e 2 not set in rules"
    ((FAIL++))
fi

# 6.3.3.21 - augenrules --check
echo ""; echo "--- 6.3.3.21: Rules loaded ---"
rules_status=$(augenrules --check 2>/dev/null)
if echo "$rules_status" | grep -q 'No change'; then
    echo "[PASS] Audit rules are loaded and current"
    ((PASS++))
else
    echo "[FAIL] Audit rules need to be loaded (run augenrules --load)"
    ((FAIL++))
fi

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
