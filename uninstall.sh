#/bin/bash

#. /etc/persist/persist.conf (or source)

# Disable systemd service
# systemctl --user disable tiny-ramdisk-ramfs-$USER
systemctl disable tiny-ramdisk-ramfs@$USER

# Unmount the volume
sudo umount $HOME/RAMDisk/

# Remove directories (mount point and persistent content)
rm -rf $HOME/RAMDisk
# rm -rf $HOME/.RAMDisk

# Clean up user scripts
# rm ${HOME}/.local/bin/tiny-ramdisk*
sudo rm /usr/local/bin/tiny-ramdisk*

# Remove systemd services
# rm ${HOME}/.config/systemd/user/tiny-ramdisk*
sudo rm /etc/systemd/system/tiny-ramdisk*
