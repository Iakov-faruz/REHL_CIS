#!/usr/bin/env bash
FAILED=0

echo "CHECK - setroubleshoot is not installed:"
RESULT=$(rpm -q setroubleshoot)
if echo "$RESULT" | grep -q "not installed"; then
    echo "CHECK - setroubleshoot not installed: PASS"
else
    echo "CHECK - setroubleshoot not installed: FAIL ($RESULT)"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.3.1.8 Ensure SETroubleshoot is not installed: PASS"
else
    echo "OVERALL - 1.3.1.8 Ensure SETroubleshoot is not installed: FAIL"
fi
