#/bin/bash

# If no argument supplied - install ramfs (dynamic ramdisk)
if [ -z "$1" ]
then
	echo "No argument supplied - installing ramfs mount"

	# Copy startup and shutdown scripts
	sudo cp ./src/tiny-ramdisk-ramfs*.sh /usr/bin
	sudo chmod +x /usr/bin/tiny-ramdisk-ramfs*

	# Copy systemd services
	# https://wiki.archlinux.org/title/systemd/User#Writing_user_units
	sudo cp ./src/tiny-ramdisk-ramfs.service /etc/systemd/system/

	# Enable systemd service
	# systemctl enable tiny-ramdisk-ramfs
	# systemctl start tiny-ramdisk-ramfs
fi
