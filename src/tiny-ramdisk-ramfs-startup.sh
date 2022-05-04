#!/bin/bash

# Create RAMDisk folder
mkdir -p $HOME/RAMDisk

# Mount ramfs to the RAMDisk folder
# sudo mount -t ramfs -o size=20m ramfs $HOME/RAMDisk
# systemd-mount -t ramfs -o size=20m ramfs $HOME/RAMDisk
# systemd-unmount $HOME/RAMDisk
mount -t ramfs -o size=20m tmpfs /home/petrstepanov/RAMDisk

# Only for ramfs - couldn't make it work via local 
# Chown the RAMDisk folder (by default its owned by root - security)
# https://unix.stackexchange.com/questions/345937/mount-ramfs-for-all-users
chown $USER:$USER /home/petrstepanov/RAMDisk

# Copy persistent content to RAMDisk (if persistent folder exists)
if [ -d "$HOME/.RAMDisk" ] 
then
    echo "Persistent foilder found. Copying content..." 
    # rsync interprets a directory with no trailing slash as `copy this directory`, and a directory with a trailing slash as copy the contents of this directory
    rsync -avzh /home/petrstepanov/.RAMDisk/ /home/petrstepanov/RAMDisk
fi
