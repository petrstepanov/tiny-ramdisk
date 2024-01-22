#!/bin/bash

# Define variables
RAMDISK_FOLDER=$HOME/RAMDisk
RAMDISK_PERSISTENT_FOLDER=$HOME/.RAMDisk

# Mount ramfs 
mkdir -p $RAMDISK_FOLDER

# Wait till shell loads
sleep 10s

# Mount the RAMDisk and change permissions
pkexec sh -c "mount -o exec $RAMDISK_FOLDER && pkexec chown $USER:$USER $RAMDISK_FOLDER"

# Copy persistent content to RAMDisk 
# Check if persistent folder exists
if [ -d "$RAMDISK_PERSISTENT_FOLDER" ] 
then
    # Check if permanent folder contains some files
    if [ "$(ls -A $RAMDISK_PERSISTENT_FOLDER)" ]; then
        # Copy preserving the ownership, mode and timestamps
        cp -a $RAMDISK_PERSISTENT_FOLDER/* $RAMDISK_FOLDER/
    fi
fi
