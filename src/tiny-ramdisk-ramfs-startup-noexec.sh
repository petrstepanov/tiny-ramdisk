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

# Wait till shell loads
# sleep 8s

# Mount the RAMDisk (no execute permissions)
mount $RAMDISK_FOLDER

# Check if persistent folder exists
if [ -d "$RAMDISK_PERSISTENT_FOLDER" ]
then
    # Check if permanent folder contains some files
    if [ "$(ls -A $RAMDISK_PERSISTENT_FOLDER)" ]; then
        # Startup notification - remember the ID to replace it with subsequent success notification
        ID=$(notify-send "${NS_ARGS[@]}" "${NS_WAIT_ARGS[@]}" --print-id "Please wait..." "Copying files to memory (RAM).")
        # Copy preserving the ownership, mode and timestamps
        cp -a $RAMDISK_PERSISTENT_FOLDER/* $RAMDISK_FOLDER/
        # Success notification
        notify-send "${NS_ARGS[@]}" "${NS_DONE_ARGS[@]}" --replace-id ${ID}  "Done!" "RAMDisk is ready. Files available for read and write only."
        # Success notification with action. In GNOME if no action was selected - it freezed the process
        # ACTION=$(notify-send "${NS_ARGS[@]}" "${NS_DONE_ARGS[@]}" --replace-id ${ID} --action "open=Show Files" --wait --expire-time 4000 "Done!" "RAMDisk is ready. Files available for read and write only.")
        # case $ACTION in
        #     open)
        #         xdg-open $RAMDISK_FOLDER;;
        #     *)
        #         ;;
        # esac
    fi
fi
