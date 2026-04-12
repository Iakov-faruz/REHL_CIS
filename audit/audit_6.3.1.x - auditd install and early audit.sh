#!/usr/bin/env bash
# CIS Benchmark: 6.3.1.1 - Ensure auditd packages are installed
# CIS Benchmark: 6.3.1.2 - Ensure auditing for processes that start prior to auditd is enabled
# Level: 2 - Server | 2 - Workstation

PASS=0
FAIL=0

echo "=============================================="
echo " CIS 6.3.1.1 - auditd Packages Installed"
echo "=============================================="

# 6.3.1.1 - Check audit and audit-libs installed
for pkg in audit audit-libs; do
    if rpm -q "$pkg" &>/dev/null; then
        echo "[PASS] 6.3.1.1: $pkg is installed: $(rpm -q $pkg)"
        ((PASS++))
    else
        echo "[FAIL] 6.3.1.1: $pkg is NOT installed"
        ((FAIL++))
    fi
done

echo ""
echo "=============================================="
echo " CIS 6.3.1.2 - audit=1 in Kernel Parameters"
echo "=============================================="

# 6.3.1.2 - Check grubby for audit=1
grubby_check=$(grubby --info=ALL 2>/dev/null | grep -Po '\baudit=1\b')
if [ -n "$grubby_check" ]; then
    echo "[PASS] 6.3.1.2: audit=1 found in grub kernel parameters"
    ((PASS++))
else
    echo "[FAIL] 6.3.1.2: audit=1 NOT found in grub kernel parameters"
    ((FAIL++))
fi

# Check /etc/default/grub
grub_default_check=$(grep -Psoi -- '^\h*GRUB_CMDLINE_LINUX=\"([^#\n\r]+\h+)?audit=1\b' /etc/default/grub 2>/dev/null)
if [ -n "$grub_default_check" ]; then
    echo "[PASS] 6.3.1.2: audit=1 found in /etc/default/grub"
    ((PASS++))
else
    echo "[FAIL] 6.3.1.2: audit=1 NOT found in /etc/default/grub"
    ((FAIL++))
fi

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
