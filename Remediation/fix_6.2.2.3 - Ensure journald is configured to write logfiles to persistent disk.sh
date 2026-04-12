#!/usr/bin/env bash
# CIS 6.2.2.3 - Ensure journald is configured to write logfiles to persistent disk
echo "=== CIS 6.2.2.3 - Fix journald Storage ==="

JOURNALD_CONF="/etc/systemd/journald.conf"

# Check if the parameter exists (either commented or active)
if grep -Pq '^\s*#?\s*Storage\s*=' "$JOURNALD_CONF" 2>/dev/null; then
    # Modify existing line
    sed -ri 's/^\s*#?\s*Storage\s*=.*/Storage=persistent/' "$JOURNALD_CONF"
else
    # Append to file if it doesn't exist
    echo "Storage=persistent" >> "$JOURNALD_CONF"
fi

systemctl restart systemd-journald
echo "[DONE] Storage=persistent configured"