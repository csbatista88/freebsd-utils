#!/bin/sh
. ./config.sh
BIN_DIR="${JAIL_DIR}/bin/* ${JAIL_DIR}/sbin/* ${JAIL_DIR}/usr/bin/* ${JAIL_DIR}/usr/sbin/* ${JAIL_DIR}/usr/libexec/*"
ldd $BIN_DIR 2>/dev/null | awk '{if (substr($NF, length($NF), 1)!=":") print $3}' | sort -u 
