#/bin/bash

echo "No argument supplied - installing ramfs mount"

# Copy startup and shutdown scripts
cp ./src/tiny-ramdisk-ramfs-startup.sh ./src/tiny-ramdisk-ramfs-startup-$USER.sh 
sed -i "s;USER;$USER;g" ./src/tiny-ramdisk-ramfs-startup-$USER.sh
sed -i "s;HOME;$HOME;g" ./src/tiny-ramdisk-ramfs-startup-$USER.sh
sudo mv ./src/tiny-ramdisk-ramfs-startup-$USER.sh /usr/bin

cp ./src/tiny-ramdisk-ramfs-shutdown.sh ./src/tiny-ramdisk-ramfs-shutdown-$USER.sh 
sed -i "s;USER;$USER;g" ./src/tiny-ramdisk-ramfs-shutdown-$USER.sh
sed -i "s;HOME;$HOME;g" ./src/tiny-ramdisk-ramfs-shutdown-$USER.sh
sudo mv ./src/tiny-ramdisk-ramfs-shutdown-$USER.sh /usr/bin

sudo chmod +x /usr/bin/tiny-ramdisk-ramfs*

# Copy systemd services
# https://wiki.archlinux.org/title/systemd/User#Writing_user_units
# sudo cp ./src/tiny-ramdisk-ramfs@.service /etc/systemd/system/tiny-ramdisk-ramfs@.service
cp ./src/tiny-ramdisk-ramfs.service ./src/tiny-ramdisk-ramfs-$USER.service
sed -i "s;USER;$USER;g" ./src/tiny-ramdisk-ramfs-$USER.service
sudo cp ./src/tiny-ramdisk-ramfs-$USER.service /etc/systemd/system/

# Enable systemd service
systemctl daemon-reload
systemctl enable tiny-ramdisk-ramfs-${USER}
systemctl start tiny-ramdisk-ramfs-${USER}
