#/bin/bash

# Copy startup and shutdown scripts
sudo cp ./src/tiny-ramdisk-ramfs-startup.sh /usr/local/bin/tiny-ramdisk-ramfs-startup-$USER.sh
sudo sed -i "s;USER;$USER;g" /usr/local/bin/tiny-ramdisk-ramfs-startup-$USER.sh
sudo sed -i "s;HOME;$HOME;g" /usr/local/bin/tiny-ramdisk-ramfs-startup-$USER.sh

sudo cp ./src/tiny-ramdisk-ramfs-shutdown.sh /usr/local/bin/tiny-ramdisk-ramfs-shutdown-$USER.sh
sudo sed -i "s;USER;$USER;g" /usr/local/bin/tiny-ramdisk-ramfs-shutdown-$USER.sh 
sudo sed -i "s;HOME;$HOME;g" /usr/local/bin/tiny-ramdisk-ramfs-shutdown-$USER.sh 

sudo chmod +x /usr/local/bin/tiny-ramdisk-ramfs*
sudo chown root:root /usr/local/bin/tiny-ramdisk-ramfs*

# Copy systemd services
# https://wiki.archlinux.org/title/systemd/User#Writing_user_units
# sudo cp ./src/tiny-ramdisk-ramfs@.service /etc/systemd/system/tiny-ramdisk-ramfs@.service
sudo cp ./src/tiny-ramdisk-ramfs@.service /etc/systemd/system/
sudo chown root:root /etc/systemd/system/tiny-ramdisk-ramfs@.service

# Enable systemd service
systemctl daemon-reload
systemctl enable tiny-ramdisk-ramfs@$USER
systemctl start tiny-ramdisk-ramfs@$USER
