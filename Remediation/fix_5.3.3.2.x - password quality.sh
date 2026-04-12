#!/usr/bin/env bash
# CIS Benchmark: 5.3.3.2.x - Password Quality (pwquality) Fix
# Covers: 5.3.3.2.1 (difok), 5.3.3.2.2 (minlen), 5.3.3.2.3 (complexity),
#         5.3.3.2.4 (maxrepeat)
# Level: 1

echo "=============================================="
echo " CIS 5.3.3.2.x - Configure Password Quality"
echo "=============================================="

PWQUALITY_CONF="/etc/security/pwquality.conf"
PWQUALITY_DIR="/etc/security/pwquality.conf.d"
mkdir -p "$PWQUALITY_DIR"

# Comment out any existing settings in main conf to avoid conflicts
echo "[INFO] Commenting out existing settings in $PWQUALITY_CONF..."
sed -ri 's/^\s*(difok|minlen|minclass|[dulo]credit|maxrepeat)\s*=/# &/' "$PWQUALITY_CONF"

# 5.3.3.2.1 - difok = 2
echo "[INFO] 5.3.3.2.1: Setting difok = 2..."
printf '%s\n' "difok = 2" > "$PWQUALITY_DIR/50-pwdifok.conf"

# 5.3.3.2.2 - minlen = 14
echo "[INFO] 5.3.3.2.2: Setting minlen = 14..."
printf '%s\n' "minlen = 14" > "$PWQUALITY_DIR/50-pwlength.conf"

# 5.3.3.2.3 - Complexity: minclass=4 + individual credits
echo "[INFO] 5.3.3.2.3: Setting password complexity..."
cat > "$PWQUALITY_DIR/50-pwcomplexity.conf" <<'EOF'
minclass = 4
dcredit = -1
ucredit = -1
ocredit = -1
lcredit = -1
EOF

# 5.3.3.2.4 - maxrepeat = 3
echo "[INFO] 5.3.3.2.4: Setting maxrepeat = 3..."
printf '%s\n' "maxrepeat = 3" > "$PWQUALITY_DIR/50-pwrepeat.conf"

# Remove any overrides from PAM files
echo "[INFO] Removing pwquality overrides from PAM files..."
for l_pam_file in system-auth password-auth; do
    pam_path="/etc/pam.d/$l_pam_file"
    if [ -f "$pam_path" ]; then
        for setting in difok minlen minclass dcredit ucredit lcredit ocredit maxrepeat; do
            sed -ri "s/(^\s*password\s+(requisite|required|sufficient)\s+pam_pwquality\.so.*)(\s+${setting}\s*=\s*\S+)(.*$)/\1\4/" "$pam_path" 2>/dev/null
        done
    fi
done

if command -v authselect &>/dev/null; then
    authselect apply-changes 2>/dev/null
fi

echo "[DONE] Password quality configuration complete."
echo ""
echo "Applied settings:"
echo "  difok = 2"
echo "  minlen = 14"
echo "  minclass = 4 (dcredit=-1, ucredit=-1, ocredit=-1, lcredit=-1)"
echo "  maxrepeat = 3"
