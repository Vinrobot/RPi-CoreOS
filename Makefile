BUTANE=./tools/butane.sh
COREOS_INSTALLER=./tools/coreos-installer.sh
CREATE_IMAGE=./tools/create-image.sh


RPI3_UEFI_ZIP_URL=https://github.com/pftf/RPi3/releases/download/v1.39/RPi3_UEFI_Firmware_v1.39.zip


all:

output/rpi3-uefi.zip:
	curl -sL "$(RPI3_UEFI_ZIP_URL)" -o $@

output/config.ign: config.bu
	$(BUTANE) --pretty --strict --output=$@ $<

.PHONY: output/fcos.img
output/fcos.img: output/config.ign output/rpi3-uefi.zip
	sudo $(CREATE_IMAGE)

output/fcos.img.gz: output/fcos.img
	pv $< | gzip -1 > $@
