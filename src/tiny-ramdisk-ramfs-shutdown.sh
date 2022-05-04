#!/bin/bash

# Create folder to save RAMDisk content
mkdir -p /home/petrstepanov/.RAMDisk

# Copy RAMDisk from memory to persistent folder
# rsync interprets a directory with no trailing slash as `copy this directory`, and a directory with a trailing slash as copy the contents of this directory
rsync -avzh /home/petrstepanov/RAMDisk/ /home/petrstepanov/.RAMDisk

# Unmount the volume
systemd-umount /home/petrstepanov/RAMDisk
