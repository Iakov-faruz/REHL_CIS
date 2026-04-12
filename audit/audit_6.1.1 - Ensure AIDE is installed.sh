#!/usr/bin/env bash
# CIS Benchmark: 6.1.1 - Ensure AIDE is installed
# Level: 1 - Server | 1 - Workstation

PASS=0
FAIL=0

echo "=============================="
echo " CIS 6.1.1 - AIDE Installation"
echo "=============================="

if rpm -q aide &>/dev/null; then
    echo "[PASS] AIDE is installed: $(rpm -q aide)"
    ((PASS++))
else
    echo "[FAIL] AIDE is NOT installed"
    ((FAIL++))
fi

# Check that aide.db.gz exists (database initialized)
if [ -f /var/lib/aide/aide.db.gz ]; then
    echo "[PASS] AIDE database exists: /var/lib/aide/aide.db.gz"
    ((PASS++))
else
    echo "[FAIL] AIDE database NOT found. Run: aide --init && mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz"
    ((FAIL++))
fi

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
