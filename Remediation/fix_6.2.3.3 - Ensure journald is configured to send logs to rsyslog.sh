#!/usr/bin/env bash
# CIS 6.2.3.3 - Ensure journald is configured to send logs to rsyslog
echo "=== CIS 6.2.3.3 - Ensure journald is configured to send logs to rsyslog ==="
JOURNALD_CONF="/etc/systemd/journald.conf"
if grep -Pq '^\s*#?\s*ForwardToSyslog\s*=' "$JOURNALD_CONF" 2>/dev/null; then
    sed -ri 's/^\s*#?\s*ForwardToSyslog\s*=.*/ForwardToSyslog=yes/' "$JOURNALD_CONF"
else
    echo "ForwardToSyslog=yes" >> "$JOURNALD_CONF"
fi
systemctl restart systemd-journald
echo "[DONE] ForwardToSyslog=yes configured"
