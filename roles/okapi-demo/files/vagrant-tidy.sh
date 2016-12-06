#!/bin/bash
cat - << EOWARNING
WARNING: This script will fill up your left over disk space.

DO NOT RUN THIS WHEN YOUR VIRTUAL HD IS RAW!!!!!!

You should NOT do this on a running system.
This is purely for making vagrant boxes damn small.

Press Ctrl+C within the next 10 seconds if you want to abort!!

EOWARNING
sleep 10;

# Remove APT cache
apt-get clean -y
apt-get autoclean -y

# Zero free space to aid VM compression
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Remove bash history
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

# Cleanup log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;

# Whiteout root
count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`;
let count--
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count;
rm /tmp/whitespace;

# Whiteout /boot
count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`;
let count--
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count;
rm /boot/whitespace;

# Whiteout swap, update fstab
swappart=`cat /proc/swaps | tail -n1 | awk -F ' ' '{print $1}'`
swapoff $swappart;
dd if=/dev/zero of=$swappart;
mkswap $swappart;
swapon $swappart;
sed -i.bak -r '/swap\s+sw/s|^UUID\=\w+\-\w+\-\w+\-\w+\-\w+|'$swappart'|' /etc/fstab;
