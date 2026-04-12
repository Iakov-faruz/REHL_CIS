#!/usr/bin/env bash
# CIS Benchmark: 5.3.3.1.x - pam_faillock Configuration Fix
# Covers: 5.3.3.1.1 (deny), 5.3.3.1.2 (unlock_time), 5.3.3.1.3 (even_deny_root)
# CIS Benchmark: 5.3.2.5 - pam_unix enabled
# Level: 1-2

echo "=============================================="
echo " CIS 5.3.x - PAM faillock & pam_unix Fix"
echo "=============================================="

FAILLOCK_CONF="/etc/security/faillock.conf"

# 5.3.2.5 - Ensure pam_unix is enabled (pwconv handles this)
echo "[INFO] 5.3.2.5: Ensuring shadowed passwords via pwconv..."
pwconv

# Create/configure faillock.conf
echo "[INFO] Configuring $FAILLOCK_CONF..."
mkdir -p /etc/security

# Set deny, unlock_time and even_deny_root
cat > "$FAILLOCK_CONF" <<'EOF'
# CIS 5.3.3.1.x - pam_faillock configuration
# 5.3.3.1.1 - Max failed attempts before lockout
deny = 5

# 5.3.3.1.2 - Unlock time in seconds (900 = 15 min)
unlock_time = 900

# 5.3.3.1.3 - Lock root account too
even_deny_root
root_unlock_time = 60

# Audit user not found attempts
audit
silent
EOF

# Remove faillock overrides from PAM files
echo "[INFO] Removing faillock overrides from PAM files..."
for l_pam_file in system-auth password-auth; do
    pam_path="/etc/pam.d/$l_pam_file"
    if [ -f "$pam_path" ]; then
        sed -ri 's/(^\s*auth\s+(requisite|required|sufficient)\s+pam_faillock\.so.*)(\s+deny\s*=\s*\S+)(.*$)/\1\4/' "$pam_path" 2>/dev/null
        sed -ri 's/(^\s*auth\s+(requisite|required|sufficient)\s+pam_faillock\.so.*)(\s+unlock_time\s*=\s*\S+)(.*$)/\1\4/' "$pam_path" 2>/dev/null
        sed -ri 's/(^\s*auth\s+(.*)\s+pam_faillock\.so.*)(\s+even_deny_root)(.*$)/\1\4/' "$pam_path" 2>/dev/null
        sed -ri 's/(^\s*auth\s+(.*)\s+pam_faillock\.so.*)(\s+root_unlock_time\s*=\s*\S+)(.*$)/\1\4/' "$pam_path" 2>/dev/null
    fi
done

# Apply authselect changes if available
if command -v authselect &>/dev/null; then
    authselect apply-changes 2>/dev/null
fi

echo "[DONE] PAM faillock configuration complete."
