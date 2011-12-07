#!/bin/bash

DEBUG=1

RAMDISK_MNT_NAME="ASRamdisk"
RAMDISK_MNT_PATH="/Volumes/"$RAMDISK_MNT_NAME
RAMDISK_ORIG_NAME="Orig.dmg"
RAMDISK_DECR_NAME="ASRamdisk.dmg"
RAMDISK_ENCR_NAME="ASRD.dmg"

KEY="774998512d4042a9da350aa07c7cd2f0e2b7c30730e88f3923e9bf029c556798"
IV="370db2a05be567e5ff81363bbb69b89e"

PAYLOAD_DIR=":/payload/"
SBIN_DIR=":/sbin/"

LAUNCHDAEMON_PLIST=$PAYLOAD_DIR"ac1dismygift.plist"
BASH=$PAYLOAD_DIR"bash"
CYDIA_PATCH=$PAYLOAD_DIR"ASCydiaPatcher"
CYDIA=$PAYLOAD_DIR"Cydia.tar.gz"
IPAD_PATCH=$PAYLOAD_DIR"K48AP.plist"
FSTAB=$PAYLOAD_DIR"fstab"
AC1DDROP=$PAYLOAD_DIR"ac1ddrop"
GZIP=$PAYLOAD_DIR"gzip"
LIBGCC=$PAYLOAD_DIR"libgcc_s.1.dylib"
LIBHISTORY=$PAYLOAD_DIR"libhistory.6.0.dylib"
LIBICONV=$PAYLOAD_DIR"libiconv.2.dylib"
LIBNCURSES=$PAYLOAD_DIR"libncurses.5.dylib"
LIBREADLINE=$PAYLOAD_DIR"libreadline.6.0.dylib"
LIBSYSTEM=$PAYLOAD_DIR"libSystem.B.dylib"
RM=$PAYLOAD_DIR"rm"
TAR=$PAYLOAD_DIR"tar"
LAUNCHD=$SBIN_DIR"launchd"


if [ $DEBUG -eq 1 ];
then
    echo $RAMDISK_MNT_NAME
    echo $RAMDISK_MNT_PATH
    echo $RAMDISK_ORIG_NAME
    echo $RAMDISK_DECR_NAME
    echo $RAMDISK_ENCR_NAME
    echo $KEY
    echo $IV
    echo $PAYLOAD_DIR
    echo $SBIN_DIR
    echo $LAUNCHDAEMON_PLIST
    echo $BASH
    echo $CYDIA_PATCH
    echo $CYDIA
    echo $IPAD_PATCH
    echo $FSTAB
    echo $AC1DDROP
    echo $GZIP
    echo $LIBGCC
    echo $LIBHISTORY
    echo $LIBICONV
    echo $LIBNCURSES
    echo $LIBREADLINE
    echo $LIBSYSTEM
    echo $RM
    echo $TAR
    echo $LAUNCHD
fi

# Build launchd
make -C src clean
make -C src

# Mount skeleton rd
hdiutil attach $RAMDISK_DECR_NAME

# Clean-up
rm -rfv $RAMDISK_MNT_PATH/payload/*
rm -rfv $RAMDISK_MNT_PATH/sbin/*

# Update
cp -rfv $LAUNCHDAEMON_PLIST $RAMDISK_MNT_PATH/payload
cp -rfv $BASH $RAMDISK_MNT_PATH/payload
cp -rfv $CYDIA_PATCH $RAMDISK_MNT_PATH/payload
cp -rfv $CYDIA $RAMDISK_MNT_PATH/payload
cp -rfv $IPAD_PATCH $RAMDISK_MNT_PATH/payload
cp -rfv $FSTAB $RAMDISK_MNT_PATH/payload
cp -rfv $AC1DDROP $RAMDISK_MNT_PATH/payload
cp -rfv $GZIP $RAMDISK_MNT_PATH/payload
cp -rfv $LIBGCC $RAMDISK_MNT_PATH/payload
cp -rfv $LIBHISTORY $RAMDISK_MNT_PATH/payload
cp -rfv $LIBICONV $RAMDISK_MNT_PATH/payload
cp -rfv $LIBNCURSES $RAMDISK_MNT_PATH/payload
cp -rfv $LIBREADLINE $RAMDISK_MNT_PATH/payload
cp -rfv $LIBSYSTEM $RAMDISK_MNT_PATH/payload
cp -rfv $RM $RAMDISK_MNT_PATH/payload
cp -rfv $TAR $RAMDISK_MNT_PATH/payload
cp -rfv $LAUNCHD $RAMDISK_MNT_PATH/sbin

# Unmount skeleton rd
hdiutil detach $RAMDISK_MNT_PATH

# Build valid rd
./xpwntool $RAMDISK_DECR_NAME $RAMDISK_ENCR_NAME -t $RAMDISK_ORIG_NAME -k $KEY -iv $IV

echo "[INFO] Done!"
