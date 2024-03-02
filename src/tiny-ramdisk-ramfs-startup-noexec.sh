#!/bin/bash

# Define variables
RAMDISK_FOLDER=$HOME/RAMDisk
RAMDISK_PERSISTENT_FOLDER=$HOME/.RAMDisk

# Create RAMDisk folder (if not exists)
mkdir -p $RAMDISK_FOLDER

# Wait till shell loads
# sleep 8s

# Mount the RAMDisk (no execute permissions)
mount $RAMDISK_FOLDER

# Check if persistent folder exists
if [ -d "$RAMDISK_PERSISTENT_FOLDER" ]
then
    # Check if permanent folder contains some files
    if [ "$(ls -A $RAMDISK_PERSISTENT_FOLDER)" ]; then
        # Copy preserving the ownership, mode and timestamps
        notify-send "Tiny RAMDisk" "Copying files..."
        cp -a $RAMDISK_PERSISTENT_FOLDER/* $RAMDISK_FOLDER/
        notify-send "Tiny RAMDisk" "Ready to use."
        # TODO: add click action
    fi
fi
