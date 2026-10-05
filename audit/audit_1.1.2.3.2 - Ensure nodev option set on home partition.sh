#!/usr/bin/env bash
# CIS Benchmark Audit: 1.1.2.3.2 Ensure nodev option set on /home partition
# Exact match to the official CIS audit command

echo "CHECK - nodev set on /home:"

# 1. אם /home אינו partition נפרד → Not Applicable (PASS)
if ! findmnt -kn /home >/dev/null 2>&1; then
    echo "CHECK - /home is not a separate partition: PASS (Not Applicable)"
    echo "OVERALL - 1.1.2.3.2 Ensure nodev option set on /home partition: PASS"
    exit 0
fi

# 2. Audit בדיוק כמו ש-CIS מבקש
if findmnt -kn /home | grep -v nodev | grep -q .; then
    echo "CHECK - nodev set on /home: FAIL"
    echo "OVERALL - 1.1.2.3.2 Ensure nodev option set on /home partition: FAIL"
    exit 1
else
    echo "CHECK - nodev set on /home: PASS"
    echo "OVERALL - 1.1.2.3.2 Ensure nodev option set on /home partition: PASS"
    exit 0
fi
