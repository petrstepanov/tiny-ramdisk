#/bin/bash

# Copy startup and shutdown scripts
mkdir -p ${HOME}/.local/bin
cp ./src/*.sh ${HOME}/.local/bin
chmod +x ${HOME}/.local/bin/tiny-ramdisk*


# Copy systemd services
# https://wiki.archlinux.org/title/systemd/User#Writing_user_units
cp ./src/*.service ${HOME}/.config/systemd/user/

# Enable systemd service
systemctl --user enable tiny-ramdisk
systemctl --user start tiny-ramdisk
