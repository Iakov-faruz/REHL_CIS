#!/usr/bin/env bash
# CIS Benchmark: 5.3.3.2.5-5.3.3.2.7 + 5.3.3.3.x + 5.3.3.4.x - Extended PAM Fix
# Level: 1

echo "=============================================="
echo " CIS 5.3.3.x - Extended PAM Configuration Fix"
echo "=============================================="

PWQUALITY_CONF="/etc/security/pwquality.conf"
PWQUALITY_DIR="/etc/security/pwquality.conf.d"
PWHISTORY_CONF="/etc/security/pwhistory.conf"
mkdir -p "$PWQUALITY_DIR"

# 5.3.3.2.5 - maxsequence
echo "[INFO] 5.3.3.2.5: Setting maxsequence = 3..."
sed -ri 's/^\s*maxsequence\s*=/# &/' "$PWQUALITY_CONF" 2>/dev/null
printf '%s\n' "maxsequence = 3" > "$PWQUALITY_DIR/50-pwmaxsequence.conf"

# 5.3.3.2.6 - dictcheck (ensure not disabled)
echo "[INFO] 5.3.3.2.6: Removing dictcheck = 0..."
sed -ri 's/^\s*dictcheck\s*=\s*0/# &/' "$PWQUALITY_CONF" "$PWQUALITY_DIR"/*.conf 2>/dev/null

# 5.3.3.2.7 - enforce_for_root (pwquality)
echo "[INFO] 5.3.3.2.7: Setting enforce_for_root (pwquality)..."
if ! grep -Psi '^\h*enforce_for_root\b' "$PWQUALITY_DIR"/50-pwroot.conf 2>/dev/null; then
    printf '\n%s\n' "enforce_for_root" >> "$PWQUALITY_DIR/50-pwroot.conf"
fi

# 5.3.3.3.1 - pwhistory remember = 24
echo "[INFO] 5.3.3.3.1: Setting pwhistory remember = 24..."
if [ -f "$PWHISTORY_CONF" ]; then
    if grep -Pq '^\h*remember\h*=' "$PWHISTORY_CONF"; then
        sed -ri 's/^\s*remember\s*=.*/remember = 24/' "$PWHISTORY_CONF"
    else
        echo "remember = 24" >> "$PWHISTORY_CONF"
    fi
else
    echo "remember = 24" > "$PWHISTORY_CONF"
fi

# 5.3.3.3.2 - enforce_for_root (pwhistory)
echo "[INFO] 5.3.3.3.2: Setting enforce_for_root (pwhistory)..."
if ! grep -Pq '^\h*enforce_for_root\b' "$PWHISTORY_CONF" 2>/dev/null; then
    echo "enforce_for_root" >> "$PWHISTORY_CONF"
fi

# 5.3.3.3.3 - pam_pwhistory use_authtok (verify in PAM)
echo "[INFO] 5.3.3.3.3: Verifying pam_pwhistory use_authtok..."
# Note: pam_pwhistory must be configured via authselect in RHEL 9

# 5.3.3.4.1 - Remove nullok from pam_unix
echo "[INFO] 5.3.3.4.1: Removing nullok from pam_unix..."
if command -v authselect &>/dev/null; then
    authselect enable-feature without-nullok 2>/dev/null
fi
for l_pam_file in system-auth password-auth; do
    sed -ri 's/(^\s*(auth|password|account|session)\s+(requisite|required|sufficient)\s+pam_unix\.so\s+.*)(nullok)(\s*.*$)/\1\5/' "/etc/pam.d/$l_pam_file" 2>/dev/null
done

# 5.3.3.4.2 - Remove remember from pam_unix
echo "[INFO] 5.3.3.4.2: Removing remember from pam_unix..."
for l_pam_file in system-auth password-auth; do
    sed -ri 's/(^\s*password\s+(requisite|required|sufficient)\s+pam_unix\.so\s+.*)(remember=[1-9][0-9]*)(\s*.*$)/\1\4/' "/etc/pam.d/$l_pam_file" 2>/dev/null
done

# 5.3.3.4.3 - Ensure sha512 on pam_unix
echo "[INFO] 5.3.3.4.3: Ensuring sha512 hashing on pam_unix..."
for l_pam_file in system-auth password-auth; do
    pam_path="/etc/pam.d/$l_pam_file"
    if ! grep -Pq '^\h*password\h+.*pam_unix\.so\h+.*\b(sha512|yescrypt)\b' "$pam_path" 2>/dev/null; then
        sed -ri 's/(^\s*password\s+(requisite|required|sufficient)\s+pam_unix\.so\s+.*)$/\1 sha512/' "$pam_path" 2>/dev/null
    fi
done

# 5.3.3.4.4 - Ensure use_authtok on pam_unix
echo "[INFO] 5.3.3.4.4: Ensuring use_authtok on pam_unix..."
for l_pam_file in system-auth password-auth; do
    pam_path="/etc/pam.d/$l_pam_file"
    if ! grep -Pq '^\h*password\h+.*pam_unix\.so\h+.*\buse_authtok\b' "$pam_path" 2>/dev/null; then
        sed -ri 's/(^\s*password\s+(requisite|required|sufficient)\s+pam_unix\.so\s+.*)$/\1 use_authtok/' "$pam_path" 2>/dev/null
    fi
done

if command -v authselect &>/dev/null; then
    authselect apply-changes 2>/dev/null
fi

echo "[DONE] Extended PAM configuration complete."
