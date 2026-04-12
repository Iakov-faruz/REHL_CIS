#!/usr/bin/env bash
# IF - the system uses UEFI (Files located in /boot/efi/EFI/*)
# Edit /etc/fstab and add fmask=0077, uid=0, and gid=0 options:
# Example:
#   <device> /boot/efi vfat defaults,umask=0027,fmask=0077,uid=0,gid=0 0 0
# Note: This may require a re-boot to enable the change.

# IF - the system uses BIOS (Files located in /boot/grub2/*)
[ -f /boot/grub2/grub.cfg ] && chown root:root /boot/grub2/grub.cfg
[ -f /boot/grub2/grub.cfg ] && chmod u-x,go-rwx /boot/grub2/grub.cfg
[ -f /boot/grub2/grubenv ] && chown root:root /boot/grub2/grubenv
[ -f /boot/grub2/grubenv ] && chmod u-x,go-rwx /boot/grub2/grubenv
[ -f /boot/grub2/user.cfg ] && chown root:root /boot/grub2/user.cfg
[ -f /boot/grub2/user.cfg ] && chmod u-x,go-rwx /boot/grub2/user.cfg
