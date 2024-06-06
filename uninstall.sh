#/bin/bash

# Define variables
BIN_FOLDER=$HOME/.local/bin
SYSTEMD_FOLDER=$HOME/.local/share/systemd/user
ICON_FOLDER=$HOME/.local/share/icons/hicolor/scalable/apps
SYMBOLIC_ICON_FOLDER=$HOME/.local/share/icons/hicolor/symbolic/apps
RAMDISK_FOLDER=$HOME/RAMDisk
RAMDISK_PERSISTENT_FOLDER=$HOME/.RAMDisk

# Stop and disable systemd service
systemctl --user stop tiny-ramdisk-ramfs
systemctl --user disable tiny-ramdisk-ramfs
systemctl --user daemon-reload

# Remove icons
rm $ICON_FOLDER/com.petrstepanov.TinyRAMDisk.svg
rm $SYMBOLIC_ICON_FOLDER/com.petrstepanov.TinyRAMDisk-symbolic.svg
xdg-desktop-menu forceupdate

# Remove systemd service file
rm $SYSTEMD_FOLDER/tiny-ramdisk*

# Wipe entry from fstab for cuerrent user
sudo sed -i "/#ramdisk-$USER/d" /etc/fstab

# Remove Policy file (if exists)
FILE=/usr/share/polkit-1/actions/com.$USER.tiny-ramdisk.policy
if [ -f "$FILE" ]; then
    sudo rm $FILE
fi

# Clean up user scripts
# rm ${HOME}/.local/bin/tiny-ramdisk*
rm $BIN_FOLDER/tiny-ramdisk*
