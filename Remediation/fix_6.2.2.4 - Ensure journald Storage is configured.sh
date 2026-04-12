#!/usr/bin/env bash
# CIS 6.2.2.4 - Ensure journald Storage is configured
echo "=== CIS 6.2.2.4 - Ensure journald Storage is configured ==="
JOURNALD_CONF="/etc/systemd/journald.conf"
if grep -Pq '^\s*#?\s*Storage\s*=' "$JOURNALD_CONF" 2>/dev/null; then
    sed -ri 's/^\s*#?\s*Storage\s*=.*/Storage=persistent/' "$JOURNALD_CONF"
else
    echo "Storage=persistent" >> "$JOURNALD_CONF"
fi
systemctl restart systemd-journald
echo "[DONE] Storage=persistent configured"
