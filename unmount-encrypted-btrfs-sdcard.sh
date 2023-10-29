export STATIC_MOUNT_POINT=/Users/$USER/static
sudo umount $STATIC_MOUNT_POINT
sudo cryptsetup close /dev/mapper/sdcard-cryptlvm
