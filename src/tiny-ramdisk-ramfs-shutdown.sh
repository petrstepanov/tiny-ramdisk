#!/bin/bash

# Create folder to save RAMDisk content
mkdir -p HOME/.RAMDisk

chown -R USER:USER HOME/.RAMDisk

# Copy RAMDisk from memory to persistent folder
# rsync interprets a directory with no trailing slash as `copy this directory`, and a directory with a trailing slash as copy the contents of this directory
rsync -avzh HOME/RAMDisk/ HOME/.RAMDisk

# Unmount the volume
umount HOME/RAMDisk

# Delete the RAMDisk folder
rm -rf HOME/RAMDisk
