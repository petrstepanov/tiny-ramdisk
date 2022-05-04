#/bin/bash

echo "No argument supplied - installing ramfs mount"

# Copy startup and shutdown scripts
cp ./src/tiny-ramdisk-ramfs-startup.sh ./src/tiny-ramdisk-ramfs-startup-$USER.sh 
sed -i "s;USER;$USER;g" ./src/tiny-ramdisk-ramfs-startup-$USER.sh
sed -i "s;HOME;$HOME;g" ./src/tiny-ramdisk-ramfs-startup-$USER.sh
sudo cp ./src/tiny-ramdisk-ramfs-startup-$USER.sh /usr/local/bin
#sudo chown root:root /usr/local/bin/tiny-ramdisk-ramfs-startup-$USER.sh

cp ./src/tiny-ramdisk-ramfs-shutdown.sh ./src/tiny-ramdisk-ramfs-shutdown-$USER.sh 
sed -i "s;USER;$USER;g" ./src/tiny-ramdisk-ramfs-shutdown-$USER.sh
sed -i "s;HOME;$HOME;g" ./src/tiny-ramdisk-ramfs-shutdown-$USER.sh
sudo cp ./src/tiny-ramdisk-ramfs-shutdown-$USER.sh /usr/local/bin
#sudo chown root:root /usr/local/bin/tiny-ramdisk-ramfs-startup-$USER.sh

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
