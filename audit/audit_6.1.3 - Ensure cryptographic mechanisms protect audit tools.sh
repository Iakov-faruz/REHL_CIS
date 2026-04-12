#!/usr/bin/env bash
# CIS Benchmark: 6.1.3 - Ensure cryptographic mechanisms protect integrity of audit tools
# Level: 1 - Server | 1 - Workstation

PASS=0
FAIL=0

echo "=================================================================="
echo " CIS 6.1.3 - AIDE Cryptographic Protection of Audit Tools"
echo "=================================================================="

AUDIT_TOOLS=(auditctl auditd ausearch aureport autrace augenrules)
REQUIRED_OPTIONS=(p i n u g s b acl xattrs sha512)

# Find aide.conf
AIDE_CONF=$(whereis aide.conf 2>/dev/null | awk '{print $2}')
if [ -z "$AIDE_CONF" ] || [ ! -f "$AIDE_CONF" ]; then
    AIDE_CONF="/etc/aide.conf"
fi

if [ ! -f "$AIDE_CONF" ]; then
    echo "[FAIL] AIDE configuration file not found at $AIDE_CONF"
    echo "       Please verify AIDE is installed."
    exit 1
fi

echo "[INFO] Using AIDE config: $AIDE_CONF"

for tool in "${AUDIT_TOOLS[@]}"; do
    tool_path=$(readlink -f "/sbin/$tool" 2>/dev/null)
    if [ -z "$tool_path" ] || [ ! -f "$tool_path" ]; then
        echo "[INFO] Audit tool '$tool' not found on this system, skipping."
        continue
    fi

    line=$(grep -P "^\s*${tool_path}\b" "$AIDE_CONF" 2>/dev/null | head -1)
    if [ -z "$line" ]; then
        echo "[FAIL] '$tool' ($tool_path) is not configured in $AIDE_CONF"
        ((FAIL++))
        continue
    fi

    missing=()
    for opt in "${REQUIRED_OPTIONS[@]}"; do
        if ! echo "$line" | grep -qP "\b${opt}\b"; then
            missing+=("$opt")
        fi
    done

    if [ "${#missing[@]}" -gt 0 ]; then
        echo "[FAIL] '$tool': missing options: ${missing[*]}"
        echo "       Found: $line"
        ((FAIL++))
    else
        echo "[PASS] '$tool' properly configured with all required options."
        ((PASS++))
    fi
done

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
