#!/usr/bin/env bash
# CIS Benchmark: 5.4.1.x and 5.4.2.x - Password Aging and Root Account Fix
# Level: 1

echo "======================================================"
echo " CIS 5.4.x - Password Aging & Root Account Fix"
echo "======================================================"

LOGIN_DEFS="/etc/login.defs"

# 5.4.1.1 - PASS_MAX_DAYS = 365
echo "[INFO] 5.4.1.1: Setting PASS_MAX_DAYS = 365..."
if grep -Pq '^\h*PASS_MAX_DAYS' "$LOGIN_DEFS"; then
    sed -ri 's/^\s*PASS_MAX_DAYS\s+.*/PASS_MAX_DAYS\t365/' "$LOGIN_DEFS"
else
    echo "PASS_MAX_DAYS	365" >> "$LOGIN_DEFS"
fi
# Fix existing users
awk -F: '($2~/^\$.+\$/) {if($5 > 365 || $5 < 1)system ("chage --maxdays 365 " $1)}' /etc/shadow

# 5.4.1.2 - PASS_MIN_DAYS = 1
echo "[INFO] 5.4.1.2: Setting PASS_MIN_DAYS = 1..."
if grep -Pq '^\h*PASS_MIN_DAYS' "$LOGIN_DEFS"; then
    sed -ri 's/^\s*PASS_MIN_DAYS\s+.*/PASS_MIN_DAYS\t1/' "$LOGIN_DEFS"
else
    echo "PASS_MIN_DAYS	1" >> "$LOGIN_DEFS"
fi
awk -F: '($2~/^\$.+\$/) {if($4 < 1)system ("chage --mindays 1 " $1)}' /etc/shadow

# 5.4.1.3 - PASS_WARN_AGE = 7
echo "[INFO] 5.4.1.3: Setting PASS_WARN_AGE = 7..."
if grep -Pq '^\h*PASS_WARN_AGE' "$LOGIN_DEFS"; then
    sed -ri 's/^\s*PASS_WARN_AGE\s+.*/PASS_WARN_AGE\t7/' "$LOGIN_DEFS"
else
    echo "PASS_WARN_AGE	7" >> "$LOGIN_DEFS"
fi
awk -F: '($2~/^\$.+\$/) {if($6 < 7)system ("chage --warndays 7 " $1)}' /etc/shadow

# 5.4.1.4 - ENCRYPT_METHOD = SHA512
echo "[INFO] 5.4.1.4: Setting ENCRYPT_METHOD = SHA512..."
if grep -Pq '^\h*ENCRYPT_METHOD' "$LOGIN_DEFS"; then
    sed -ri 's/^\s*ENCRYPT_METHOD\s+.*/ENCRYPT_METHOD SHA512/' "$LOGIN_DEFS"
else
    echo "ENCRYPT_METHOD SHA512" >> "$LOGIN_DEFS"
fi

# 5.4.1.5 - INACTIVE = 45
echo "[INFO] 5.4.1.5: Setting INACTIVE = 45..."
useradd -D -f 45
awk -F: '($2~/^\$.+\$/) {if($7 > 45 || $7 < 0)system ("chage --inactive 45 " $1)}' /etc/shadow

# 5.4.2.1 - Ensure root is only UID 0
echo "[INFO] 5.4.2.1: Checking UID 0 accounts..."
uid0_users=$(awk -F: '($3 == 0 && $1 != "root") { print $1 }' /etc/passwd)
if [ -n "$uid0_users" ]; then
    echo "[WARN] Non-root accounts with UID 0: $uid0_users - manual fix required"
fi

# 5.4.2.2 - Root is only GID 0 primary
echo "[INFO] 5.4.2.2: Verifying root GID..."
usermod -g 0 root 2>/dev/null

# 5.4.2.3 - root group is only GID 0 group
echo "[INFO] 5.4.2.3: Verifying group GID 0..."
groupmod -g 0 root 2>/dev/null

# 5.4.2.4 - Root access controlled (verify only)
echo "[INFO] 5.4.2.4: Root access status..."
root_status=$(passwd -S root 2>/dev/null | awk '{print $2}')
echo "  Root password status: $root_status"

echo "[DONE] Password aging and root account configuration complete."
