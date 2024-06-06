#/bin/bash

# TODO: parameterise the RAMDisk folder name via template systemd service @
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
read -p "QUESTION: Do you need executable permissions on the RAMDisk? (yes/no) " yn
case $yn in 
    yes )
        echo -e "INFO: Ok. Copying startup and shutdown scripts."
        cp ./src/tiny-ramdisk-ramfs-startup-exec.sh $BIN_FOLDER/tiny-ramdisk-ramfs-startup.sh
        cp ./src/tiny-ramdisk-ramfs-shutdown-exec.sh $BIN_FOLDER/tiny-ramdisk-ramfs-shutdown.sh
        echo -e "INFO: Installing the policy file."
        sudo cp ./src/com.tiny-ramdisk.policy /usr/share/polkit-1/actions
        sudo mv /usr/share/polkit-1/actions/com.tiny-ramdisk.policy /usr/share/polkit-1/actions/com.$USER.tiny-ramdisk.policy
        sudo sed -i "s;%USER%;$USER;g" /usr/share/polkit-1/actions/com.$USER.tiny-ramdisk.policy
        break;;
    no )
        echo -e "INFO: Ok. Copying startup and shutdown scripts."
        cp ./src/tiny-ramdisk-ramfs-startup-noexec.sh $BIN_FOLDER/tiny-ramdisk-ramfs-startup.sh
        cp ./src/tiny-ramdisk-ramfs-shutdown-noexec.sh $BIN_FOLDER/tiny-ramdisk-ramfs-shutdown.sh
        break;;
    * ) echo invalid response;;
esac
done

# Add executable permissions to RAMDisk scripts
chmod +x $BIN_FOLDER/tiny-ramdisk-ramfs*

# Install icons for notifications and pkexec dialog (if needed)
echo "INFO: Installing application icons."
mkdir -p $ICON_FOLDER
mkdir -p $SYMBOLIC_ICON_FOLDER
cp ./resources/com.petrstepanov.TinyRAMDisk.svg $ICON_FOLDER
cp ./resources/com.petrstepanov.TinyRAMDisk-symbolic.svg $SYMBOLIC_ICON_FOLDER
xdg-desktop-menu forceupdate

# Create folder for user systemd scripts
echo "INFO: Installing systemd service."
mkdir -p $SYSTEMD_FOLDER

# Copy systemd services
# https://wiki.archlinux.org/title/systemd/User#Writing_user_units
cp ./src/tiny-ramdisk-ramfs.service $SYSTEMD_FOLDER

# Instantiate the service
systemctl --user stop tiny-ramdisk-ramfs
systemctl --user disable tiny-ramdisk-ramfs
systemctl --user daemon-reload

systemctl --user enable tiny-ramdisk-ramfs
echo "INFO: Starting the RAMDisk service..."
systemctl --user start tiny-ramdisk-ramfs

# Show RAMDisk folder in Files application
echo "INFO: Done! Path to your RAMDisk is ${RAMDISK_FOLDER}"
xdg-open $RAMDISK_FOLDER
