#!/bin/bash

# Create RAMDisk folder
mkdir -p HOME/RAMDisk

# Mount ramfs to the RAMDisk folder
mount -t ramfs -o size=20m tmpfs HOME/RAMDisk

# Only for ramfs: chown the RAMDisk folder (by default its owned by root for security purposes)
# This is why we cannot install the ramfs systemd service for per-user
# tmpfs may be installed as per-user possibly
# https://unix.stackexchange.com/questions/345937/mount-ramfs-for-all-users
chown USER:USER HOME/RAMDisk

# Copy persistent content to RAMDisk (if persistent folder exists)
if [ -d "HOME/.RAMDisk" ] 
then
    echo "Persistent folder found. Copying content..." 
    # rsync interprets a directory with no trailing slash as `copy this directory`, and a directory with a trailing slash as copy the contents of this directory
    rsync -avzh HOME/.RAMDisk/ HOME/RAMDisk
fi
