#/bin/bash

# Define variables
BIN_FOLDER=$HOME/.local/bin
SYSTEMD_FOLDER=$HOME/.local/share/systemd/user
ICON_FOLDER=$HOME/.local/share/icons/hicolor/scalable/apps
SYMBOLIC_ICON_FOLDER=$HOME/.local/share/icons/hicolor/symbolic/apps
RAMDISK_FOLDER=$HOME/RAMDisk
RAMDISK_PERSISTENT_FOLDER=$HOME/.RAMDisk

# Stop and remove systemd service
echo "INFO: Disabling and removing the systemd service."
systemctl --user stop tiny-ramdisk
systemctl --user disable tiny-ramdisk
systemctl --user daemon-reload

# Remove systemd service file
rm $SYSTEMD_FOLDER/tiny-ramdisk*

# Remove icons
echo "INFO: Removing app icons."
rm $ICON_FOLDER/tiny-ramdisk.svg
rm $SYMBOLIC_ICON_FOLDER/tiny-ramdisk-symbolic.svg
xdg-desktop-menu forceupdate

# Wipe entry from fstab for cuerrent user
echo "INFO: Removing the fstab entry."
sudo sed -i "/#ramdisk-$USER/d" /etc/fstab

# Remove Policy file (if exists)
echo "INFO: Wiping user policy file."
FILE=/usr/share/polkit-1/actions/tiny-ramdisk.$USER.policy
if [ -f "$FILE" ]; then
    sudo rm $FILE
fi

# Clean up user scripts
echo "INFO: Cleaning up user scripts."
rm $BIN_FOLDER/tiny-ramdisk-*

# Success exit
echo "INFO: RAMDisk is deleted! Your files are stored in ${RAMDISK_PERSISTENT_FOLDER}"
exit 0
