#!/bin/sh

exec docker run --rm -it --pull=always \
	--privileged \
	-v /run/udev:/run/udev \
	-v /dev:/dev \
	-v "$(pwd):/pwd" \
	-w /pwd \
	quay.io/coreos/coreos-installer:release \
	"$@"
