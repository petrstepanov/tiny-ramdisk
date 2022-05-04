#!/bin/bash

# Create RAMDisk folder
mkdir -p /home/petrstepanov/RAMDisk

# Mount ramfs to the RAMDisk folder
mount -t ramfs -o size=20m tmpfs /home/petrstepanov/RAMDisk

# Only for ramfs: chown the RAMDisk folder (by default its owned by root for security purposes)
# This is why we cannot install the ramfs systemd service for per-user
# tmpfs may be installed as per-user possibly
# https://unix.stackexchange.com/questions/345937/mount-ramfs-for-all-users
chown petrstepanov:petrstepanov /home/petrstepanov/RAMDisk

# Copy persistent content to RAMDisk (if persistent folder exists)
if [ -d "/home/petrstepanov/.RAMDisk" ] 
then
    echo "Persistent folder found. Copying content..." 
    # rsync interprets a directory with no trailing slash as `copy this directory`, and a directory with a trailing slash as copy the contents of this directory
    rsync -avzh /home/petrstepanov/.RAMDisk/ /home/petrstepanov/RAMDisk
fi
