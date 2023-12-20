#!/bin/bash

# Define variables
RAMDISK_FOLDER=$HOME/RAMDisk
RAMDISK_PERSISTENT_FOLDER=$HOME/.RAMDisk

# Mount ramfs 
mount $RAMDISK_FOLDER

# Copy persistent content to RAMDisk (if persistent folder exists)
if [ -d "$RAMDISK_PERSISTENT_FOLDER" ] 
then
    echo "Persistent folder found. Copying content..." 
    # copy preserving the ownership, mode and timestamps
    # sudo -u USER cp -a HOME/$RAMDISK_PERSISTENT_FOLDER/. HOME/$RAMDISK_FOLDER/
    cp -a $RAMDISK_PERSISTENT_FOLDER/* $RAMDISK_FOLDER/
fi
