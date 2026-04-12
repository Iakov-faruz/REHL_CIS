#!/usr/bin/env bash
# CIS 6.2.2.2 - Ensure journald ForwardToSyslog is disabled
echo "=== CIS 6.2.2.2 - Ensure journald ForwardToSyslog is disabled ==="
JOURNALD_CONF="/etc/systemd/journald.conf"
if grep -Pq '^\s*#?\s*ForwardToSyslog\s*=' "$JOURNALD_CONF" 2>/dev/null; then
    sed -ri 's/^\s*#?\s*ForwardToSyslog\s*=.*/ForwardToSyslog=no/' "$JOURNALD_CONF"
else
    echo "ForwardToSyslog=no" >> "$JOURNALD_CONF"
fi
systemctl restart systemd-journald
echo "[DONE] ForwardToSyslog=no configured"
