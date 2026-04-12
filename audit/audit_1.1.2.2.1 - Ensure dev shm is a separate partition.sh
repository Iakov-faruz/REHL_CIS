#!/usr/bin/env bash
# IF: /dev/shm is to be used on the system.
FAILED=0

echo "CHECK - /dev/shm is mounted:"
RESULT=$(findmnt -kn /dev/shm)
if [ -n "$RESULT" ]; then
    echo "CHECK - /dev/shm is mounted: PASS"
else
    echo "CHECK - /dev/shm is mounted: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.2.1 Ensure /dev/shm is a separate partition: PASS"
else
    echo "OVERALL - 1.1.2.2.1 Ensure /dev/shm is a separate partition: FAIL"
fi
