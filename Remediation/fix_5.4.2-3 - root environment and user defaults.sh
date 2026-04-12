#!/usr/bin/env bash
# CIS Benchmark: 5.4.2.5-5.4.3.3 - Root Environment and User Defaults Fix
# Level: 1

echo "======================================================"
echo " CIS 5.4.2.5-5.4.3.3 - Root Env & User Defaults Fix"
echo "======================================================"

# 5.4.2.6 - Root umask (fix in .bashrc/.bash_profile)
echo "[INFO] 5.4.2.6: Fixing root umask..."
for f in /root/.bash_profile /root/.bashrc; do
    [ -f "$f" ] && sed -ri 's/^\s*(umask\s+[0-7]+)/#\1/' "$f"
done

# 5.4.2.7 - System accounts without nologin
echo "[INFO] 5.4.2.7: Setting system account shells to nologin..."
l_valid_shells="^($( awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\/{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
awk -v pat="$l_valid_shells" -F: '($1!~/^(root|halt|sync|shutdown|nfsnobody)$/ && ($3<'"$UID_MIN"' || $3 == 65534) && $(NF) ~ pat) {system ("usermod -s '"$(command -v nologin)"' " $1)}' /etc/passwd

# 5.4.2.8 - Lock accounts without valid login shell
echo "[INFO] 5.4.2.8: Locking accounts without valid login shell..."
while IFS= read -r l_user; do
    passwd -S "$l_user" 2>/dev/null | awk '$2 !~ /^L/ {system ("usermod -L " $1)}'
done < <(awk -v pat="$l_valid_shells" -F: '($1 != "root" && $(NF) !~ pat) {print $1}' /etc/passwd)

# 5.4.3.1 - Remove nologin from /etc/shells
echo "[INFO] 5.4.3.1: Removing nologin from /etc/shells..."
sed -ri '/\/nologin\b/d' /etc/shells 2>/dev/null

# 5.4.3.2 - Configure TMOUT
echo "[INFO] 5.4.3.2: Configuring TMOUT = 900..."
# Remove any existing TMOUT configurations
for f in /etc/bashrc /etc/profile; do
    [ -f "$f" ] && sed -ri 's/^\s*(.*TMOUT.*)/#\1/' "$f"
done
# Set TMOUT in /etc/profile.d/
printf '%s\n' "# CIS 5.4.3.2 - Set shell timeout to 900 seconds" "typeset -xr TMOUT=900" > /etc/profile.d/50-tmout.sh

# 5.4.3.3 - Default user umask
echo "[INFO] 5.4.3.3: Setting default user umask..."
# Comment out any bad umask settings
for f in /etc/bashrc /etc/profile /etc/login.defs; do
    [ -f "$f" ] && sed -ri 's/^\s*(umask\s+[0-7]+)/#\1/' "$f"
done
# Set proper umask
printf '%s\n' "umask 027" > /etc/profile.d/50-systemwide_umask.sh

echo "[DONE] Root environment and user defaults configured."
echo ""
echo "Applied settings:"
echo "  - Root umask: commented out permissive settings"
echo "  - System accounts: set to nologin"
echo "  - Non-login accounts: locked"
echo "  - nologin: removed from /etc/shells"
echo "  - TMOUT: 900 seconds"
echo "  - Default umask: 027"
