#!/bin/sh


BASE_MVT=""

# Check if mvt is already installed
MVT_IOS="mvt-ios"
MVT_ANDROID="mvt-android"
PYTHON_VER=$(python3 -V|cut -d" " -f2)

BREW_BASE_MVT="/usr/local/bin"
BREW_MVT="${BREW_BASE_MVT}/${MVT_IOS}"

USERDIR_BASE_MVT="${HOME}/Library/Python/${PYTHON_VER%.*}/bin"
USERDIR_MVT="${USERDIR_BASE_MVT}/${MVT_IOS}"

if [ -x "${BREW_MVT}" ]; then
    BASE_MVT=${BREW_BASE_MVT}
fi
if [ -x "${USERDIR_MVT}" ]; then
    BASE_MVT=${USERDIR_BASE_MVT}
fi

if [ "${BASE_MVT}" = "" ]; then
    echo "Installing MVT"
    pip3 install mvt --user
    BASE_MVT=${USERDIR_BASE_MVT}
fi

DEVICE_CHOICE=0
until [ $DEVICE_CHOICE -eq 1 ] || [ $DEVICE_CHOICE -eq 2 ]; do
    echo 
    echo "What do you want to scan?"
    echo " 1) Android Device"
    echo " 2) iOS Device"
    read -r DEVICE_CHOICE
done

echo 

case $DEVICE_CHOICE in
    1 )
        echo "Connect your Android Device now, then press Enter"
        read -r
        "${BASE_MVT}/${MVT_ANDROID}" check-adb
        ;;
    2 )
        echo "Locating your iPhone backups"
        BACKUP_DIR="${HOME}/Library/Application Support/MobileSync/Backup"
        ls -l "${BACKUP_DIR}"
        BACKUP_IPHONE="invalid_folder"
        until [ -d "${BACKUP_DIR}/${BACKUP_IPHONE}" ]; do
            echo 
            echo "Copy/paste the name of the backup you wish to scan"
            read -r BACKUP_IPHONE
        done

        "${BASE_MVT}/${MVT_IOS}" check-backup "${BACKUP_DIR}/${BACKUP_IPHONE}"
        ;;
esac