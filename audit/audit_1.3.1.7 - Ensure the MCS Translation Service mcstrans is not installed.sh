#!/usr/bin/env bash
FAILED=0

echo "CHECK - mcstrans is not installed:"
RESULT=$(rpm -q mcstrans)
if echo "$RESULT" | grep -q "not installed"; then
    echo "CHECK - mcstrans not installed: PASS"
else
    echo "CHECK - mcstrans not installed: FAIL ($RESULT)"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.3.1.7 Ensure the MCS Translation Service (mcstrans) is not installed: PASS"
else
    echo "OVERALL - 1.3.1.7 Ensure the MCS Translation Service (mcstrans) is not installed: FAIL"
fi
