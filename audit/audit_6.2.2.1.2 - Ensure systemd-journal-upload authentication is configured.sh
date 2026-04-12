#!/usr/bin/env bash
# CIS 6.2.2.1.2 - Ensure systemd-journal-upload authentication is configured
PASS=0; FAIL=0
echo "=== CIS 6.2.2.1.2 - Ensure systemd-journal-upload authentication is configured ==="
if grep -Pqs '^\s*URL=\S+' /etc/systemd/journal-upload.conf && grep -Pqs '^\s*ServerKeyFile=\S+' /etc/systemd/journal-upload.conf && grep -Pqs '^\s*ServerCertificateFile=\S+' /etc/systemd/journal-upload.conf && grep -Pqs '^\s*TrustedCertificateFile=\S+' /etc/systemd/journal-upload.conf; then
echo "[PASS] journal-upload authentication configured"; ((PASS++))
else echo "[FAIL] journal-upload authentication missing/incomplete"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
