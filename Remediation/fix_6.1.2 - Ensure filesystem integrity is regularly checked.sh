#!/usr/bin/env bash
# CIS Benchmark: 6.1.2 - Ensure filesystem integrity is regularly checked
# Level: 1 - Server | 1 - Workstation
# Uses systemd timer method (recommended)

echo "============================================="
echo " CIS 6.1.2 - Schedule AIDE Integrity Check"
echo "============================================="

# Create aidecheck.service
cat > /etc/systemd/system/aidecheck.service <<'EOF'
[Unit]
Description=Aide Check

[Service]
Type=simple
ExecStart=/usr/sbin/aide --check

[Install]
WantedBy=multi-user.target
EOF

# Create aidecheck.timer
cat > /etc/systemd/system/aidecheck.timer <<'EOF'
[Unit]
Description=Aide check every day at 5AM

[Timer]
OnCalendar=*-*-* 05:00:00
Unit=aidecheck.service

[Install]
WantedBy=multi-user.target
EOF

chown root:root /etc/systemd/system/aidecheck.*
chmod 0644 /etc/systemd/system/aidecheck.*

systemctl daemon-reload
systemctl enable aidecheck.service
systemctl --now enable aidecheck.timer

echo "[DONE] AIDE check scheduled daily at 5AM via systemd timer."
