#!/bin/sh

. ./config.sh

#Tarring everything to a tar.bz2 file
cd ${START_PATH}
tar jcvf ${HOME}/minibsd-${RELEASE}.tar.bz2 *

#Copying everything to ${MOUNT_POINT}
cd ${MOUNT_POINT}
tar jxvfP ${START_PATH}/minibsd-${RELEASE}.tar.bz2
cd ${START_PATH}
umount ${MOUNT_POINT}
