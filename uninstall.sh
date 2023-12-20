#/bin/bash

BIN_FOLDER=$HOME/.local/bin
SYSTEMD_FOLDER=$HOME/.local/share/systemd/user
RAMDISK_FOLDER=$HOME/RAMDisk
RAMDISK_PERSISTENT_FOLDER=$HOME/.RAMDisk

# Stop and disable systemd service
systemctl --user stop tiny-ramdisk-ramfs
systemctl --user disable tiny-ramdisk-ramfs
systemctl --user daemon-reload

# Remove systemd service file
rm $SYSTEMD_FOLDER/tiny-ramdisk*

# Wipe entry from fstab for cuerrent user
sudo sed -i "/#ramdisk-$USER/d" /etc/fstab

# Remove ramdisk folder (but keep data in the persistent folder)
# sudo rm -rf $RAMDISK_FOLDER

# Clean up user scripts
# rm ${HOME}/.local/bin/tiny-ramdisk*
rm $BIN_FOLDER/tiny-ramdisk*
