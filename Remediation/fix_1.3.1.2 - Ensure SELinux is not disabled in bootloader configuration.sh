#!/usr/bin/env bash
grubby --update-kernel ALL --remove-args "selinux=0 enforcing=0"

# Also handle configs created by deprecated grub2-mkconfig:
grep -Prsq -- '\h*([^#\n\r]+\h+)?kernelopts=([^#\n\r]+\h+)?(selinux|enforcing)=0\b' \
 /boot/grub2 /boot/efi && grub2-mkconfig -o "$(grep -Prl -- \
 '\h*([^#\n\r]+\h+)?kernelopts=([^#\n\r]+\h+)?(selinux|enforcing)=0\b' \
 /boot/grub2 /boot/efi)"
