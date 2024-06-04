#!/bin/sh

exec docker run --rm -it --pull=always \
	-v "$(pwd):/pwd" \
	-w /pwd \
	quay.io/coreos/butane:release \
	"$@"
