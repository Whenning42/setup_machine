#!/bin/bash

USER="william"
USER_PASS="FILL_IN"
ROOT_PASS="FILL_IN"
TIMEZONE="America/Detroit"

# Arch install script for an intel graphics laptop (thinkpad X1 gen 13).
# The fdisk commands aren't finished. The mkfs command assumes the device's
# paritions are using the NVME naming scheme.

# Partition Disk
lsblk
read -p "Select a device to install to. Warning: All partitions will be wiped. Device: " DEVICE
# Make the rest of the disk filesystem
echo "Selected this disk to install to: "
fdisk -l $device
read -p "Confirm wipe [y/N]" CONFIRM
if [[ $CONFIRM =~ ^[Yy]$ ]]
then
  # TODO: Finish partition steps
  (
  echo g # Create the GPT table
  echo n # Add the boot partition
  echo p # Primary partition
  echo 1 # Partition number
  echo   # Accept default first sector 
  echo +1GB  # Make it 1GB
  echo n # Add a swap partition
  echo ? 
  echo ?
  echo ?
  echo n # Add the filesystem parition
  echo ?
  echo w # Write changes
  ) | fdisk

  EFI_PART="$DEVICEp1"
  SWAP_PART="$DEVICEp2"
  ROOT_PART="$DEVICEp3"
  mkfs.ext4 "$ROOT_PART"
else
  exit
fi

# Mount the file system
mount $ROOT_PART /mnt
mount --mkdir $EFI_PARTH /mnt/boot
swapon $SWAP_PART

# Install base packages
pacstrap -K /mnt base linux linux-firmware

# Setup the fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot
arch-chroot /mnt

# Set the timezone and hwclock
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

# Localization
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Setup the network
read -p "Host Name?" HOSTNAME
echo $HOSTNME >> /etc/hostname
pacman -S iwd
# Setup iwd
systemctl enable --now iwctl
cat << EOF > /etc/iwd/main.conf
[General]
EnableNetworkConfiguration=true
EOF
# Setup systemd-resolve
systemctl enable --now systemd-resolved
ln -sf ../run/systemd/resolve/sub-resolv.conf /etc/resolv.conf

# Set root password
echo "$ROOT_PASS" | passwd

# Install GRUB
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
exit

# Create user
useradd -m $USER
groupadd wheel
usermod --append --groups wheel $USER
echo "$USER_PASS" | passwd $USER

# Write default sudoers file
cat << EOF > /etc/sudoers
%wheel ALL=(ALL:ALL) ALL
$USER ALL= NOPASSWD: /usr/bin/halt,/usr/bin/poweroff,/usr/bin/reboot,/usr/bi
n/pacman -Syu
EOF

# Install packages
pacman -S sudo
pacman -S firefox
pacman -S python
pacman -S i3
pacman -S devel-base
pacman -S git
pacman -S xorg-server
pacman -S xorg-sev
pacman -S xorg-xrandr
pacman -S xorg-xset
pacman -S kmix
pacman -S redshift
pacman -S pulseaudio
pacman -S pulseaudio-bluetooth
pacman -S bluez
pacman -S bluez-utils

# Install AV drivers
# Intel graphics
pacman -S mesa
pacman -S vulkan-intel
pacman -S xf86-video-intel

# Intel audio
pacman -S sof-firmware

# Install power management
pacman -S acpi

# Install all of the user's configs
sudo -H -u $USER install_user_configs.sh
