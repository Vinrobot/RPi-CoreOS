#!/bin/bash

IMAGE=output/fcos.img
CONFIG=output/config.ign
EFI_ZIP=output/rpi3-uefi.zip


set -ex


if ! [ -f "$IMAGE" ]; then
	TMP_IMAGE="$(mktemp --suffix=.img)"
	fallocate -l 4G "$TMP_IMAGE"
	mv "$TMP_IMAGE" "$IMAGE"
fi

IMAGE_DEV="$(losetup --find --show --nooverlap --partscan $IMAGE)"

./tools/coreos-installer.sh install \
	--architecture aarch64 \
	--ignition-file output/config.ign \
	"$IMAGE_DEV"

EFI_PART="$(lsblk $IMAGE_DEV -J -oLABEL,PATH | jq -r '.blockdevices[] | select(.label == "EFI-SYSTEM")'.path)"

EFI_DIR="$(mktemp -d)"
mount "$EFI_PART" "$EFI_DIR"
unzip "$EFI_ZIP" -d "$EFI_DIR"
umount "$EFI_DIR"
rmdir "$EFI_DIR"

# Fix MBR table for Raspberry Pi 3
# https://discussion.fedoraproject.org/t/fcos-unusually-slow-on-raspberry-pi-3b/40635/16
sgdisk --hybrid=2:EE "$IMAGE_DEV"
gdisk "$IMAGE_DEV" <<EOF
r
h
2
N
0E
Y
N
w
Y

EOF

losetup -d "$IMAGE_DEV"
