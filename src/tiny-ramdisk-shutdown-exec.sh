#!/bin/bash

# Define variables
RAMDISK_FOLDER="${HOME}/RAMDisk"
RAMDISK_PERSISTENT_FOLDER="${HOME}/.RAMDisk"
SYMBOLIC_ICON_FOLDER="${HOME}/.local/share/icons/hicolor/symbolic/apps"

NS_ARGS=(--icon tiny-ramdisk-symbolic --app-name "Tiny RAMDisk")
NS_WAIT_ARGS=(--hint "string:image-path:${SYMBOLIC_ICON_FOLDER}/tiny-ramdisk-wait-symbolic.svg" --category transfer)
NS_DONE_ARGS=(--hint "string:image-path:${SYMBOLIC_ICON_FOLDER}/tiny-ramdisk-done-symbolic.svg" --category transfer.complete)

# Create folder to save RAMDisk content
mkdir -p $RAMDISK_PERSISTENT_FOLDER

# Copy files from ramdisk (memory) to persistent folder
# rsync interprets a directory with no trailing slash as `copy this directory`, and a directory with a trailing slash as copy the contents of this directory
# --recursive           -r  recurse into directories
# --links               -l  copy symlinks as symlinks
# --ignore-existing         skip updating files that exist on receiver
# --times               -t  preserve modification times
# --verbose             -v  increase verbosity
# --delete                  delete extraneous files from dest dirs

ID=$(notify-send "${NS_ARGS[@]}" "${NS_WAIT_ARGS[@]}" --print-id "Please wait..." "Synchronizing RAMDisk files to persistent location.")

rsync -avul --delete $RAMDISK_FOLDER/ $RAMDISK_PERSISTENT_FOLDER

notify-send "${NS_ARGS[@]}" "${NS_DONE_ARGS[@]}" --replace-id ${ID}  "Done!" "Files are saved to persistent location."

# Unmount the volume with lazy option because `Target is Busy`
pkexec chown root:root $RAMDISK_FOLDER
pkexec umount --lazy $RAMDISK_FOLDER
pkexec rm -rf $RAMDISK_FOLDER

# Success exit
exit 0
