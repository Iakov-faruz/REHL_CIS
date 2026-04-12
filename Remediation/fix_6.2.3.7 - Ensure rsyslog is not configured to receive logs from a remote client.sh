#!/usr/bin/env bash
# CIS 6.2.3.7 - Ensure rsyslog is not configured to receive logs from a remote client
echo "=== CIS 6.2.3.7 - Ensure rsyslog is not configured to receive logs from a remote client ==="
sed -ri 's/^\s*(\$ModLoad\s+imtcp)/#\1/' /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null
sed -ri 's/^\s*(\$InputTCPServerRun)/#\1/' /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null
systemctl restart rsyslog
echo "[DONE] Remote reception disabled"
