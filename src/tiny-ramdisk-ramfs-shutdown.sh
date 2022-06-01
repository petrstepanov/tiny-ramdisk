#!/bin/bash

# Create folder to save RAMDisk content
mkdir -p HOME/.RAMDisk

chown -R USER:USER HOME/.RAMDisk

# Copy RAMDisk from memory to persistent folder
# rsync interprets a directory with no trailing slash as `copy this directory`, and a directory with a trailing slash as copy the contents of this directory
# --recursive           -r  recurse into directories
# --links               -l  copy symlinks as symlinks
# --ignore-existing         skip updating files that exist on receiver
# --times               -t  preserve modification times
# --verbose             -v  increase verbosity
# --delete                  delete extraneous files from dest dirs

rsync --recursive --links --ignore-existing --delete HOME/RAMDisk/ HOME/.RAMDisk

# Unmount the volume
umount HOME/RAMDisk

# Delete the RAMDisk folder
rm -rf HOME/RAMDisk
