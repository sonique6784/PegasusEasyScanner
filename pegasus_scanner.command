#!/bin/sh


BASE_MVT=""
# Check if mvt is already installed
BREW_MVT_IOS=/usr/local/bin/mvt-ios
USERDIR_MVT=~/Library/Python/3.8/bin/mvt-ios
if [ -x $BREW_MVT_IOS ]; then
    BASE_MVT=/usr/local/bin
fi
if [ -x $USERDIR_MVT ]; then
    BASE_MVT=~/Library/Python/3.8/bin
fi

if [ "$BASE_MVT" = "" ]; then
    echo "Installing MVT"
    pip3 install mvt --user
fi

DEVICE_CHOICE=0
until [ $DEVICE_CHOICE -eq 1 ] || [ $DEVICE_CHOICE -eq 2 ]; do
    echo "do you want to scan"
    echo " 1) Android Device"
    echo " 2) iOS Device"
    read DEVICE_CHOICE
done

if [ $DEVICE_CHOICE -eq 1 ]; then
    echo "Connect your Android Device now, then press Enter"
    read
    $BASE_MVT/mvt-android check-adb
else
    if [ $DEVICE_CHOICE -eq 2 ]; then
        echo "Locating your iPhone backups"
        ls -l ~/Library/Application\ Support/MobileSync/Backup
        BACKUP_IPHONE="invalid_folder"
        until [ -d ~/Library/Application\ Support/MobileSync/Backup/$BACKUP_IPHONE ]; do
            echo "Copy/paste the back you which to scan"
            read BACKUP_IPHONE
        done

        $BASE_MVT/mvt-ios check-backup ~/Library/Application\ Support/MobileSync/Backup/$BACKUP_IPHONE
    fi
fi

