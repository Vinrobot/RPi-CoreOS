#!/bin/sh

DISK=/dev/mmcblk0

set -ex

sgdisk --hybrid=2:EE "$DISK"
gdisk "$DISK" <<EOF
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
