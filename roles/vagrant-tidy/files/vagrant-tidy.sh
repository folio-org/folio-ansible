#!/bin/bash
# WARNING: This script will fill up your left over disk space.

# DO NOT RUN THIS WHEN YOUR VIRTUAL HD IS RAW!!!!!!

# You should NOT do this on a running system.
# This is purely for making vagrant boxes damn small.

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

# Zero free space to aid VM compression
dd if=/dev/zero of=/EMPTY bs=1M 2>/dev/null
sync
rm -f /EMPTY
sync
