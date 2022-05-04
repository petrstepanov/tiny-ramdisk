#/bin/bash

# If no argument supplied - install ramfs (dynamic ramdisk)
if [ -z "$1" ]
then
	echo "No argument supplied - installing ramfs mount"

	# Copy startup and shutdown scripts
	cp ./src-local/tiny-ramdisk-ramfs*.sh ${HOME}/.local/bin
	chmod +x ${HOME}/.local/bin/tiny-ramdisk*

	# Copy systemd services
	# https://wiki.archlinux.org/title/systemd/User#Writing_user_units
	cp ./src-local/tiny-ramdisk-ramfs.service ${HOME}/.config/systemd/user/

	# Enable systemd service
	# systemctl daemon-reload
	# systemctl --user enable tiny-ramdisk-ramfs
	# systemctl --user start tiny-ramdisk-ramfs
fi
