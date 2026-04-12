#!/usr/bin/env bash
# CIS Benchmark: 5.3.3.2.x - Password Quality (pwquality) Audit
# Covers: 5.3.3.2.1 (difok), 5.3.3.2.2 (minlen), 5.3.3.2.3 (complexity),
#         5.3.3.2.4 (maxrepeat)
# Level: 1

PASS=0
FAIL=0

echo "=============================================="
echo " CIS 5.3.3.2.x - Password Quality Audit"
echo "=============================================="

PWQUALITY_DIR="/etc/security/pwquality.conf.d"
PWQUALITY_CONF="/etc/security/pwquality.conf"

# 5.3.3.2.1 - difok >= 2
echo ""
echo "--- 5.3.3.2.1: difok (changed characters) ---"
difok=$(grep -Psi -- '^\h*difok\h*=\h*([2-9]|[1-9][0-9]+)\b' "$PWQUALITY_CONF" "$PWQUALITY_DIR"/*.conf 2>/dev/null)
if [ -n "$difok" ]; then
    echo "[PASS] $difok"
    ((PASS++))
else
    echo "[FAIL] difok not set to 2 or more"
    ((FAIL++))
fi

# 5.3.3.2.2 - minlen >= 14
echo ""
echo "--- 5.3.3.2.2: minlen (password length) ---"
minlen=$(grep -Psi -- '^\h*minlen\h*=\h*(1[4-9]|[2-9][0-9]|[1-9][0-9]{2,})\b' "$PWQUALITY_CONF" "$PWQUALITY_DIR"/*.conf 2>/dev/null)
if [ -n "$minlen" ]; then
    echo "[PASS] $minlen"
    ((PASS++))
else
    echo "[FAIL] minlen not set to 14 or more"
    ((FAIL++))
fi

# 5.3.3.2.3 - Complexity (minclass=4 or dcredit/ucredit/ocredit/lcredit = -1)
echo ""
echo "--- 5.3.3.2.3: Password Complexity ---"
minclass=$(grep -Psi -- '^\h*minclass\h*=\h*4\b' "$PWQUALITY_CONF" "$PWQUALITY_DIR"/*.conf 2>/dev/null)
dcredit=$(grep -Psi -- '^\h*dcredit\h*=\h*-[1-9]' "$PWQUALITY_CONF" "$PWQUALITY_DIR"/*.conf 2>/dev/null)
ucredit=$(grep -Psi -- '^\h*ucredit\h*=\h*-[1-9]' "$PWQUALITY_CONF" "$PWQUALITY_DIR"/*.conf 2>/dev/null)
ocredit=$(grep -Psi -- '^\h*ocredit\h*=\h*-[1-9]' "$PWQUALITY_CONF" "$PWQUALITY_DIR"/*.conf 2>/dev/null)
lcredit=$(grep -Psi -- '^\h*lcredit\h*=\h*-[1-9]' "$PWQUALITY_CONF" "$PWQUALITY_DIR"/*.conf 2>/dev/null)

if [ -n "$minclass" ]; then
    echo "[PASS] $minclass"
    ((PASS++))
elif [ -n "$dcredit" ] && [ -n "$ucredit" ] && [ -n "$ocredit" ] && [ -n "$lcredit" ]; then
    echo "[PASS] Individual credit requirements set: dcredit, ucredit, ocredit, lcredit"
    ((PASS++))
else
    echo "[FAIL] Password complexity not properly configured (set minclass=4 or all credit options)"
    ((FAIL++))
fi

# 5.3.3.2.4 - maxrepeat (1-3, not 0)
echo ""
echo "--- 5.3.3.2.4: maxrepeat (consecutive characters) ---"
maxrepeat=$(grep -Psi -- '^\h*maxrepeat\h*=\h*[1-3]\b' "$PWQUALITY_CONF" "$PWQUALITY_DIR"/*.conf 2>/dev/null)
if [ -n "$maxrepeat" ]; then
    echo "[PASS] $maxrepeat"
    ((PASS++))
else
    echo "[FAIL] maxrepeat not set to 1-3"
    ((FAIL++))
fi

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
