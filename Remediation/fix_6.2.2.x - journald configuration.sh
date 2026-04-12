#!/usr/bin/env bash
# CIS Benchmark: 6.2.2.x Combined Remediation
# Covers: 6.2.2.1.1, 6.2.2.1.3, 6.2.2.1.4, 6.2.2.2, 6.2.2.3, 6.2.2.4
# NOTE: Apply only if journald is the chosen logging system (not rsyslog)

echo "================================================"
echo " CIS 6.2.2.x - journald Configuration Fix"
echo "================================================"
echo "[NOTE] Edit REMOTE_LOG_URL below to match your log server before running!"
REMOTE_LOG_URL="192.168.50.42"

# 6.2.2.1.1 - Install systemd-journal-remote
if ! rpm -q systemd-journal-remote &>/dev/null; then
    echo "[INFO] Installing systemd-journal-remote..."
    dnf install -y systemd-journal-remote
fi

# 6.2.2.1.4 - Mask the receive side (client should not receive logs)
echo "[INFO] 6.2.2.1.4: Masking journal-remote receive services..."
systemctl stop systemd-journal-remote.socket systemd-journal-remote.service 2>/dev/null
systemctl mask systemd-journal-remote.socket systemd-journal-remote.service

# 6.2.2.1.2 / 6.2.2.1.3 - Configure and enable journal-upload
echo "[INFO] 6.2.2.1.2: Configuring journal-upload..."
mkdir -p /etc/systemd
cat > /etc/systemd/journal-upload.conf.d/cis.conf <<EOF
[Upload]
URL=${REMOTE_LOG_URL}
ServerKeyFile=/etc/ssl/private/journal-upload.pem
ServerCertificateFile=/etc/ssl/certs/journal-upload.pem
TrustedCertificateFile=/etc/ssl/ca/trusted.pem
EOF

echo "[INFO] 6.2.2.1.3: Enabling systemd-journal-upload..."
systemctl unmask systemd-journal-upload.service 2>/dev/null
systemctl --now enable systemd-journal-upload.service

# 6.2.2.2, 6.2.2.3, 6.2.2.4 - journald.conf settings
echo "[INFO] Configuring /etc/systemd/journald.conf.d/60-cis-journald.conf..."
mkdir -p /etc/systemd/journald.conf.d/
cat > /etc/systemd/journald.conf.d/60-cis-journald.conf <<'EOF'
[Journal]
ForwardToSyslog=no
Compress=yes
Storage=persistent
SystemMaxUse=1G
SystemKeepFree=500M
RuntimeMaxUse=200M
RuntimeKeepFree=50M
MaxFileSec=1month
EOF

systemctl reload-or-restart systemd-journald
echo "[DONE] journald configuration complete."
