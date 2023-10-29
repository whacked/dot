export STATIC_MOUNT_POINT=/Users/$USER/static
if [ ! -e $STATIC_MOUNT_POINT ]; then
    mkdir -p $STATIC_MOUNT_POINT
fi

BLOCK_DEVICE=/dev/mmcblk0p1
if ! $(sudo cryptsetup isLuks $BLOCK_DEVICE 2>/dev/null); then
    echo "ERROR: sdcard is not a luks volume"
    exit
fi

if [ $(lsblk /dev/mmcblk0 | grep crypt | wc -l) -gt 0 ]; then
    echo "luks appears to be already opened"
else
    echo "opening luks volume..."
    sudo cryptsetup open /dev/mmcblk0p1 sdcard-cryptlvm
fi

if [ $(mount | grep $STATIC_MOUNT_POINT | wc -l) -gt 0 ]; then
    echo "$STATIC_MOUNT_POINT appears to be already mounted"
else
    sudo mount /dev/mapper/sdcard-cryptlvm $STATIC_MOUNT_POINT
    sudo chown $USER: $STATIC_MOUNT_POINT
fi

du -sh $STATIC_MOUNT_POINT
