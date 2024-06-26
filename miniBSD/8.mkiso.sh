#!/bin/sh

. ./config.sh

cd ${JAIL_DIR}
/usr/local/bin/mkisofs -b boot/cdboot -no-emul-boot -c boot/boot.catalog -R -J -V miniBSD -o ${ISO_FILE} .
cd ${START_PATH}
