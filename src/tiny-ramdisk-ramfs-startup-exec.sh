#!/bin/bash

# Define variables
RAMDISK_FOLDER=$HOME/RAMDisk
RAMDISK_PERSISTENT_FOLDER=$HOME/.RAMDisk

# Create RAMDisk folder (if not exists)
mkdir -p $RAMDISK_FOLDER

# Wait till shell loads
sleep 8s

# Mount the RAMDisk and change permissions
# pkexec sh -c "mount -o exec $RAMDISK_FOLDER && chown $USER:$USER $RAMDISK_FOLDER"
pkexec mount -o exec $RAMDISK_FOLDER
pkexec chown $USER:$USER $RAMDISK_FOLDER

# Check pkexec status
# https://linux.die.net/man/1/pkexec

auth=$?

echo "Authorization"
echo $auth

if [ $auth = 0 ]; then
    # Copy persistent content to RAMDisk 
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
            # TODO: add icon to notify-send
        fi
    fi
elif [ $auth = 126 ]; then
    notify-send "Tiny RAMDisk" "Start failed"
fi
