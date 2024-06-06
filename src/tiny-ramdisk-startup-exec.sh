#!/bin/bash

# Define variables
RAMDISK_FOLDER=$HOME/RAMDisk
RAMDISK_PERSISTENT_FOLDER=$HOME/.RAMDisk

# Man page for notify-send: https://specifications.freedesktop.org/notification-spec/notification-spec-latest.html
#                           https://man.archlinux.org/man/notify-send.1.en
# Pass command args with quotes as bash variable: https://superuser.com/a/360986/206515
NS_ARGS=(--icon com.petrstepanov.TinyRAMDisk-symbolic --app-name "Tiny RAMDisk")
NS_WAIT_ARGS=(--hint "string:image-path:face-yawn-symbolic" --category transfer)
NS_DONE_ARGS=(--hint "string:image-path:face-smile-big-symbolic" --category transfer.complete)
NS_FAIL_ARGS=(--hint "string:image-path:face-sad-symbolic" --category transfer.error)

# Create RAMDisk folder (if not exists)
mkdir -p $RAMDISK_FOLDER

# Mount the RAMDisk and change permissions
pkexec mount -o exec $RAMDISK_FOLDER
pkexec chown $USER:$USER $RAMDISK_FOLDER

# Check pkexec status: https://linux.die.net/man/1/pkexec
auth=$?

echo "Authorization"
echo $auth

if [ $auth = 0 ]; then
    # Copy persistent content to RAMDisk
    # Check if persistent folder exists
    if [ -d "$RAMDISK_PERSISTENT_FOLDER" ]
    then
        # Check if permanent folder contains some files
        if [ "$(ls -A $RAMDISK_PERSISTENT_FOLDER)" ]; then
            # Startup notification - remember the ID to replace it with subsequent success notification
            ID=$(notify-send "${NS_ARGS[@]}" "${NS_WAIT_ARGS[@]}" --print-id "Please wait..." "Copying files to memory (RAM).")
            echo $ID
            # Copy preserving the ownership, mode and timestamps
            cp -a $RAMDISK_PERSISTENT_FOLDER/* $RAMDISK_FOLDER/
            # Success notification
            notify-send "${NS_ARGS[@]}" "${NS_DONE_ARGS[@]}" --replace-id ${ID} "Done!" "RAMDisk is ready to use."
            # Success notification with action. In GNOME if no action was selected - it freezed the process
            # ACTION=$(notify-send "${NS_ARGS[@]}" "${NS_DONE_ARGS[@]}" --replace-id ${ID} --action "open=Show Files" --wait --expire-time 4000 "Done!" "RAMDisk is ready to use.")
            # case $ACTION in
            #     open)
            #         xdg-open $RAMDISK_FOLDER;;
            #     *)
            #         ;;
            # esac
        fi
    fi
elif [ $auth = 126 ]; then
    # Error notification
    notify-send "${NS_ARGS[@]}" "${NS_FAIL_ARGS[@]}" "Oops!" "Error copying persistent files to RAM."
fi

# Success exit
exit 0