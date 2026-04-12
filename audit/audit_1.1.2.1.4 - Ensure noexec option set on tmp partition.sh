#!/usr/bin/env bash
# IF: a separate partition exists for /tmp, verify that the noexec option is set.
FAILED=0

echo "CHECK - noexec set on /tmp:"
RESULT=$(findmnt -kn /tmp | grep -v noexec)
if [ -z "$RESULT" ]; then
    echo "CHECK - noexec set on /tmp: PASS"
else
    echo "CHECK - noexec set on /tmp: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.1.4 Ensure noexec option set on /tmp partition: PASS"
else
    echo "OVERALL - 1.1.2.1.4 Ensure noexec option set on /tmp partition: FAIL"
fi
