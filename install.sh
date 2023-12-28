#/bin/bash

# TODO: parameterise the RAMDisk folder name via template systemd service @

BIN_FOLDER=$HOME/.local/bin
SYSTEMD_FOLDER=$HOME/.local/share/systemd/user
RAMDISK_FOLDER=$HOME/RAMDisk
RAMDISK_PERSISTENT_FOLDER=$HOME/.RAMDisk

# Create folder to mount ramfs
# mkdir -p $RAMDISK_FOLDER

# Create entry in /etc/fstab
# RAMDisk is not mounted automatically, user service will mount at login
# https://forums.linuxmint.com/viewtopic.php?t=123354
sudo sed -i "/#ramdisk-$USER/d" /etc/fstab
echo "none $RAMDISK_FOLDER ramfs rw,exec,noauto,user,mode=1777 0 0 #ramdisk-$USER" | sudo tee -a /etc/fstab

# Update fstab
sudo systemctl daemon-reload

# Copy startup and shutdown scripts
# Tip: copying, not moving because copying inherits file properties, of its parent directory (ownership, etc).
# https://osric.com/chris/accidental-developer/2019/01/cp-mv-ownership-attributes/
mkdir -p $BIN_FOLDER

# Need exec permissions?
while true; do
read -p "Do you need executable permissions on the RAMDisk? (yes/no) " yn
case $yn in 
	yes ) echo ok;
	        cp ./src/tiny-ramdisk-ramfs-startup-exec.sh $BIN_FOLDER/tiny-ramdisk-ramfs-startup.sh
                cp ./src/tiny-ramdisk-ramfs-shutdown-exec.sh $BIN_FOLDER/tiny-ramdisk-ramfs-shutdown.sh
		break;;
	no ) echo ok;
	        cp ./src/tiny-ramdisk-ramfs-startup-noexec.sh $BIN_FOLDER/tiny-ramdisk-ramfs-startup.sh
                cp ./src/tiny-ramdisk-ramfs-shutdown-noexec.sh $BIN_FOLDER/tiny-ramdisk-ramfs-shutdown.sh
		break;;
	* ) echo invalid response;;
esac
done

chmod +x $BIN_FOLDER/tiny-ramdisk-ramfs*

# Create folder for user systemd scripts
mkdir -p $SYSTEMD_FOLDER

# Copy systemd services
# https://wiki.archlinux.org/title/systemd/User#Writing_user_units
cp ./src/tiny-ramdisk-ramfs.service $SYSTEMD_FOLDER

# Instantiate the service
systemctl --user stop tiny-ramdisk-ramfs
systemctl --user disable tiny-ramdisk-ramfs
systemctl --user daemon-reload

systemctl --user enable tiny-ramdisk-ramfs
echo Waiting for the service to start...
systemctl --user start tiny-ramdisk-ramfs

# Open ramdisk folder in Files
notify-send "Tiny RAMDisk" "Path to your RAMDisk is $RAMDISK_FOLDER"
xdg-open $RAMDISK_FOLDER
