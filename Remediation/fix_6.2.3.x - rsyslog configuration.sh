#!/usr/bin/env bash
# CIS Benchmark: 6.2.3.x Combined Remediation
# Covers: 6.2.3.1, 6.2.3.2, 6.2.3.3, 6.2.3.4, 6.2.3.7
# NOTE: Apply only if rsyslog is the chosen logging system (not journald)
# NOTE: Edit REMOTE_LOGHOST below to match your log server

REMOTE_LOGHOST="loghost.example.com"

echo "============================================"
echo " CIS 6.2.3.x - rsyslog Hardening"
echo "============================================"
echo "[NOTE] Edit REMOTE_LOGHOST at top of script before running!"

# 6.2.3.1 - Install rsyslog
if ! rpm -q rsyslog &>/dev/null; then
    echo "[INFO] Installing rsyslog..."
    dnf install -y rsyslog
fi

# 6.2.3.2 - Enable and start rsyslog
echo "[INFO] 6.2.3.2: Enabling rsyslog..."
systemctl unmask rsyslog.service
systemctl enable rsyslog.service
systemctl start rsyslog.service

# 6.2.3.3 - Configure journald to forward to rsyslog
echo "[INFO] 6.2.3.3: Setting ForwardToSyslog=yes in journald..."
mkdir -p /etc/systemd/journald.conf.d/
cat > /etc/systemd/journald.conf.d/60-cis-rsyslog.conf <<'EOF'
[Journal]
ForwardToSyslog=yes
EOF
systemctl reload-or-restart systemd-journald.service

# 6.2.3.4 - Set FileCreateMode to 0640
echo "[INFO] 6.2.3.4: Setting \$FileCreateMode 0640..."
RSYSLOG_CIS="/etc/rsyslog.d/60-cis.conf"
if ! grep -q '^\$FileCreateMode' "$RSYSLOG_CIS" 2>/dev/null; then
    echo '$FileCreateMode 0640' >> "$RSYSLOG_CIS"
else
    sed -i 's/^\$FileCreateMode.*/\$FileCreateMode 0640/' "$RSYSLOG_CIS"
fi

# 6.2.3.5 - Configure log destinations
echo "[INFO] 6.2.3.5: Configuring log destinations..."
cat >> "$RSYSLOG_CIS" <<'EOF'

# CIS 6.2.3.5 - Logging rules
*.emerg :omusrmsg:*
auth,authpriv.* /var/log/secure
mail.* -/var/log/mail
cron.* /var/log/cron
*.=warning;*.=err -/var/log/warn
*.crit /var/log/warn
*.*;mail.none;news.none -/var/log/messages
EOF

# 6.2.3.6 - Configure remote log forwarding
echo "[INFO] 6.2.3.6: Configuring remote log forwarding to $REMOTE_LOGHOST..."
cat >> "$RSYSLOG_CIS" <<EOF

# CIS 6.2.3.6 - Remote log forwarding
*.* action(type="omfwd" target="${REMOTE_LOGHOST}" port="514" protocol="tcp"
  action.resumeRetryCount="100"
  queue.type="LinkedList" queue.size="1000")
EOF

# 6.2.3.7 - Remove any imtcp (receive) configuration
echo "[INFO] 6.2.3.7: Removing any imtcp (receive) configuration..."
for f in /etc/rsyslog.conf /etc/rsyslog.d/*.conf; do
    [ -f "$f" ] && sed -i '/module(load="imtcp")/Id; /input(type="imtcp"/Id; /\$ModLoad imtcp/Id; /\$InputTCPServerRun/Id' "$f"
done

systemctl restart rsyslog
echo "[DONE] rsyslog configuration complete."
