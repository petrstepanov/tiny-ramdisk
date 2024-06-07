#/bin/bash

# TODO: parameterise the RAMDisk folder name via template systemd service @
# TODO: use reverse dns naming com.github.petrstepanov.tiny-ramdisk to avoid name clashes
BIN_FOLDER=$HOME/.local/bin
SYSTEMD_FOLDER=$HOME/.local/share/systemd/user
ICON_FOLDER=$HOME/.local/share/icons/hicolor/scalable/apps
SYMBOLIC_ICON_FOLDER=$HOME/.local/share/icons/hicolor/symbolic/apps
RAMDISK_FOLDER=$HOME/RAMDisk
RAMDISK_PERSISTENT_FOLDER=$HOME/.RAMDisk

# Create entry in /etc/fstab
echo "INFO: Creating ramfs entry in /etc/fstab."
sudo sed -i "/#ramdisk-$USER/d" /etc/fstab
echo "none $RAMDISK_FOLDER ramfs rw,exec,noauto,user,mode=1777 0 0 #ramdisk-$USER" | sudo tee -a /etc/fstab

# Make `mount` recognize changes in `fstab`: https://unix.stackexchange.com/q/477794/340672
sudo systemctl daemon-reload

# Copy startup and shutdown scripts
# Tip: copying, not moving because copying inherits file properties, of its parent directory (ownership, etc).
# https://osric.com/chris/accidental-developer/2019/01/cp-mv-ownership-attributes/
mkdir -p $BIN_FOLDER

# Check which RAMDisk scripts to install - with or without executable permissions on the drive?
while true; do
read -p "QUESTION: Do you need executable permissions on the RAMDisk? (yes/no) " YN
case $YN in 
    yes )
        echo -e "INFO: Ok. Copying startup and shutdown scripts."
        cp ./src/tiny-ramdisk-startup-exec.sh $BIN_FOLDER/tiny-ramdisk-startup.sh
        cp ./src/tiny-ramdisk-shutdown-exec.sh $BIN_FOLDER/tiny-ramdisk-shutdown.sh
        echo -e "INFO: Installing the policy file."
        sudo cp ./src/tiny-ramdisk.policy /usr/share/polkit-1/actions
        sudo mv /usr/share/polkit-1/actions/tiny-ramdisk.policy /usr/share/polkit-1/actions/tiny-ramdisk.$USER.policy
        sudo sed -i "s;%USER%;$USER;g" /usr/share/polkit-1/actions/tiny-ramdisk.$USER.policy
        break;;
    no )
        echo -e "INFO: Ok. Copying startup and shutdown scripts."
        cp ./src/tiny-ramdisk-startup-noexec.sh $BIN_FOLDER/tiny-ramdisk-startup.sh
        cp ./src/tiny-ramdisk-shutdown-noexec.sh $BIN_FOLDER/tiny-ramdisk-shutdown.sh
        break;;
    * ) 
        echo invalid response
        exit 1
        break;;
esac
done

# Add executable permissions to RAMDisk scripts
chmod +x $BIN_FOLDER/tiny-ramdisk-*

# Install application icon for pkexec dialog (may be needed)
# All icons are installed to "hicolor" fallback icon theme folder: https://askubuntu.com/a/300155/925071
echo "INFO: Installing application icons."
mkdir -p $ICON_FOLDER
cp ./resources/tiny-ramdisk.svg $ICON_FOLDER
xdg-desktop-menu forceupdate

# Install symbolic icons for notifications
mkdir -p $SYMBOLIC_ICON_FOLDER
cp ./resources/tiny-ramdisk*symbolic.svg $SYMBOLIC_ICON_FOLDER
gtk-update-icon-cache --ignore-theme-index $HOME/.local/share/icons/hicolor/

# Create folder for user systemd scripts
echo "INFO: Installing systemd service."
mkdir -p $SYSTEMD_FOLDER

# Copy systemd services
# https://wiki.archlinux.org/title/systemd/User#Writing_user_units
cp ./src/tiny-ramdisk.service $SYSTEMD_FOLDER

# Instantiate the service
systemctl --user stop tiny-ramdisk
systemctl --user disable tiny-ramdisk
systemctl --user daemon-reload

systemctl --user enable tiny-ramdisk
echo "INFO: Starting the RAMDisk service..."
systemctl --user start tiny-ramdisk

# Show RAMDisk folder in Files application
echo "INFO: Done! Path to your RAMDisk is ${RAMDISK_FOLDER}"
xdg-open $RAMDISK_FOLDER

# Success exit
exit 0
