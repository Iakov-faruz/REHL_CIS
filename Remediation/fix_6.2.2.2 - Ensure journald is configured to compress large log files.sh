#!/usr/bin/env bash
# CIS 6.2.2.2 - Ensure journald is configured to compress large log files
echo "=== CIS 6.2.2.2 - Fix journald Compress ==="

JOURNALD_CONF="/etc/systemd/journald.conf"

if grep -Pq '^\s*#?\s*Compress\s*=' "$JOURNALD_CONF" 2>/dev/null; then
    sed -ri 's/^\s*#?\s*Compress\s*=.*/Compress=yes/' "$JOURNALD_CONF"
else
    echo "Compress=yes" >> "$JOURNALD_CONF"
fi

systemctl restart systemd-journald
echo "[DONE] Compress=yes configured"
