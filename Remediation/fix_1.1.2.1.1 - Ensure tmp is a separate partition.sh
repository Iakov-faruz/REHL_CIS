#!/usr/bin/env bash
# IF: an entry for /tmp exists in /etc/fstab it will take precedence over
# entries in systemd default unit file.
# Ensure systemd mounts /tmp at boot time:
systemctl unmask tmp.mount
# Edit /etc/fstab to configure /tmp with required mount options.
# Example using tmpfs:
#   tmpfs /tmp tmpfs defaults,rw,nosuid,nodev,noexec,relatime,size=2G 0 0
# Example using a volume or disk:
#   <device> /tmp <fstype> defaults,nodev,nosuid,noexec 0 0
