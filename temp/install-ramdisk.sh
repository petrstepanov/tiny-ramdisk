#/bin/bash

# Stop if running
if command -v p3x-ramdisk &> /dev/null
then
    echo "p3x-ramdisk found. Stopping"
    sudo p3x-ramdisk stop $USER
fi

# How-to: install-ramdisk.sh 2048

# Install RAMDisk
sudo dnf -y install npm

# if npm was installed without local previlleges
sudo npm install -g p3x-ramdisk --unsafe-perm=true --allow-root

# Obtain RAMDisk size from parameter
SIZE=${1:-3072}

# According to https://wiki.archlinux.org/title/systemd/User
# all systemd units should be placed here
RAMDISK_DIR=.ramdisk
RAMDISK_PERSISTENT_DIR=.ramdisk-persistent

# Generate service and script files
sudo p3x-ramdisk install petrstepanov -s ${SIZE} -r ${RAMDISK_DIR} -p ${RAMDISK_PERSISTENT_DIR}

# Specify partition in fstab
# Delete line containing "RAMDisk" from fstab (if exists)
sudo sed -i "/gid=10000,uid=10000/d" /etc/fstab
# Add RAMDisk to fstab
echo "tmpfs                                     ${HOME}/${RAMDISK_DIR}        tmpfs   gid=10000,uid=10000,size=${SIZE}M   0 0" | sudo tee -a /etc/fstab
tmpfs                                     ${HOME}/${RAMDISK_DIR}        tmpfs   gid=10000,uid=10000,size=${SIZE}M   0 0" | sudo tee -a /etc/fstab

# Mount RAMDisk
echo "Mounting partition..."
sudo mount -a

# Check everything is ok
echo "Checking everything is ok..."
df -h

# Replace home paths with bin paths in .service files
echo "Replacing home paths with bin paths in .service files..."
# sudo mv ${HOME}/.p3x-ramdisk/p3x-ramdisk.sh /usr/bin/
# sed -i "s;${HOME}/.p3x-ramdisk/;/usr/bin/;" ~/.p3x-ramdisk/*.service

# Remove the RAMDisk script in home folder (just in case)
# echo "Removing the RAMDisk script in home folder (just in case)..."
# rm ${HOME}/.p3x-ramdisk/p3x-ramdisk.sh

# Start service
echo "Starting service..."
sudo p3x-ramdisk start $USER

# Create symboilc link to persistent RAMDisk in $HOME
echo "Creating symboilc links to persistent RAMDisk in $HOME..."
MY_RAMDISK_DIR=RAMDisk
rm $HOME/${MY_RAMDISK_DIR}
ln -s $HOME/${RAMDISK_DIR}/.p3x-ramdisk-persistence/content $HOME/${MY_RAMDISK_DIR}
