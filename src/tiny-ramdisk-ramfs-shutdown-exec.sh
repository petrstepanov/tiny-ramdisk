#!/bin/bash

# Define variables
RAMDISK_FOLDER=$HOME/RAMDisk
RAMDISK_PERSISTENT_FOLDER=$HOME/.RAMDisk

# Create folder to save RAMDisk content
mkdir -p $PERSISTENT_FOLDER

# Copy files from ramdisk (memory) to persistent folder
# rsync interprets a directory with no trailing slash as `copy this directory`, and a directory with a trailing slash as copy the contents of this directory
# --recursive           -r  recurse into directories
# --links               -l  copy symlinks as symlinks
# --ignore-existing         skip updating files that exist on receiver
# --times               -t  preserve modification times
# --verbose             -v  increase verbosity
# --delete                  delete extraneous files from dest dirs

rsync -avul --delete $RAMDISK_FOLDER/ $RAMDISK_PERSISTENT_FOLDER

# Unmount the volume
pkexec chown root:root $RAMDISK_FOLDER
pkexec umount -f $RAMDISK_FOLDER
pkexec rm -rf $RAMDISK_FOLDER
