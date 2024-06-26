#!/bin/sh

. ./config.sh
if [ "${CHAIN}" = "Y" ]; then
  printf "\033[1;36m6.create_img.sh\033[0m\n"
fi

if [ "${RELEASE}" = "4" ]; then
  LABEL_CMD="/sbin/disklabel"
else
  LABEL_CMD="/sbin/bsdlabel"
fi

if [ ! "${CHAIN}" = "Y" ]; then
  echo -n "Device where your CF card is attached [${DEF_DEV}]: "
  read DEVICE
  if [ "${DEVICE}" = "" ]; then
    DEVICE="${DEF_DEV}"
  fi
else
  DEVICE="${DEF_DEV}"
fi

reset_device() {
echo -n "Retrieving sectors information for ${DEVICE}" 
if [ "${RELEASE}" = "4" ]; then
  /bin/dd if=/dev/zero of=/dev/${DEVICE} bs=512 count=32 > /dev/null 2>&1
  /sbin/fdisk -BI ${DEVICE} > /dev/null 2>&1
  /bin/dd if=/dev/zero of=/dev/${DEVICE}s1 bs=512 count=32 > /dev/null 2>&1
  ${LABEL_CMD} -w -B ${DEVICE}s1 auto > /dev/null 2>&1
  DEF_SECTORS=`disklabel -r "${DEVICE}"s1 | grep sectors/unit | cut -d\  -f 2`
else
  DEF_SECTORS=`bsdlabel -A "${DEVICE}" | grep sectors/unit | cut -d\  -f 2`
fi
print_ok

if [ "${DEF_SECTORS}" = "" ]; then
  echo "Something goes wrong. Try to write a standard label in ${DEVICE}, with the following command:"
  echo "# /sbin/bsdlabel -w ${DEVICE}"
fi

if [ ! "${CHAIN}" = "Y" ]; then
  echo -n "How many sectors do you want for the image [${DEF_SECTORS}]: " 
  read SECTORS
  if [ "${SECTORS}" = "" ]; then
    SECTORS="${DEF_SECTORS}" 
  fi
else
  SECTORS="${DEF_SECTORS}"
fi

echo -n "Creating ${DEST_FILE}... " 
dd if=/dev/zero of=${DEST_FILE} bs=512 count=${SECTORS} > /dev/null 2>&1
print_ok

echo -n "Generating minibsd-disk via md... " 
if [ "${RELEASE}" = "4" ]; then
  SOFT_DEVICE="vn4"
  vnconfig -s labels -c ${SOFT_DEVICE} ${DEST_FILE} > /dev/null 2>&1 
else
  SOFT_DEVICE="md4"
  mdconfig -a -t vnode -f ${DEST_FILE} -u 4  > /dev/null 2>&1
fi
print_ok
  
echo -n "Creating disk layout file... " 
LAYOUT_FILE="disk_layout"

${LABEL_CMD} -Brw ${SOFT_DEVICE} auto  > /dev/null 2>&1
${LABEL_CMD} ${SOFT_DEVICE} > ${LAYOUT_FILE}

ed << EOF > /dev/null
e ${LAYOUT_FILE}
$
i
  a:  ${SECTORS}  0  4.2BSD  0 0
.
w
q
EOF

${LABEL_CMD} -R ${SOFT_DEVICE} ${LAYOUT_FILE} > /dev/null 2>&1
${LABEL_CMD} -R ${DEVICE}s1a ${LAYOUT_FILE} > /dev/null 2>&1
rm -f ${LAYOUT_FILE}
print_ok
}

format_cf() {
  FORM="Y"
  if [ ! "${CHAIN}" = "Y" ]; then
    echo -n "Do You want to format your flash card [Y]? "
    read FORM
  fi
  if [ "${FORM}" = "Y" -o "${FORM}" = "y" ]; then
    echo -n "Formatting... " && /sbin/newfs -b 8192 -f 1024 -U /dev/${DEVICE}s1a > /dev/null 2>&1 
  fi
  print_ok
}

ANS="Y"
if [ ! "${CHAIN}" = "Y" ]; then
  echo -n "Do You want to change your flash card physical layout [N]? "
  read ANS
fi
if [ "${ANS}" = "Y" -o "${ANS}" = "y" ]; then
  reset_device
  echo -n "Formatting... " 
  /sbin/newfs -b 8192 -f 1024 -U /dev/${SOFT_DEVICE}a > /dev/null 2>&1
  print_ok
fi

if [ "${ANS}" != "Y" -a "${ANS}" != "y" ]; then
  format_cf
fi

if [ ! -d ${MOUNT_POINT} ]; then
  mkdir -p ${MOUNT_POINT}
fi

if [ "${SOFT_DEVICE}" = "" ]; then
  /sbin/mount /dev/${DEVICE}s1a ${MOUNT_POINT}
else
  /sbin/mount /dev/${SOFT_DEVICE}a ${MOUNT_POINT}
fi

echo "Your flash card is now mounted in ${MOUNT_POINT}."
echo "You are begin to install minibsd in ${DEST_DIR}"
echo ""
if [ ! "${CHAIN}" = "Y" ]; then
  echo "If there is something wrong in this setup please"
  echo "press CTRL+C or wait 10 seconds to continue..."
fi

cd ${JAIL_DIR}
echo -n "Copy in progress... " 
find . -depth -print | cpio -pvudm ${DEST_DIR} > /dev/null 2>&1 && sync && sync && sync && print_ok

echo "MINIBSD installation on ${DEST_DIR} is finished."
echo ""
echo "Please edit your ${DEST_DIR}/etc/files to suit your needs."
echo ""

echo "Customize /etc/fstab..."
echo -n "Enter the / entry for your miniBSD system [ad0s1a]: "
read ROOT
if [ "${ROOT}" = "" ]; then
  ROOT="ad0s1a"
fi
printf "/dev/${ROOT}\t/\tufs\trw\t1\t1\n" > ${DEST_DIR}/etc/fstab

echo "Choose a password for root..."
/usr/sbin/chroot ${DEST_DIR} /usr/bin/passwd root

echo -n "Unmounting ${DEST_DIR}..." 
umount ${DEST_DIR} && print_ok

if [ ! "${SOFT_DEVICE}" = "" ]; then 
  if [ "${RELEASE}" = "4" ]; then 
    vnconfig -u vn4
  else
    mdconfig -d -u 4
  fi
  echo -n "Dump ${DEST_FILE} to flash card" 
  /bin/dd if=${DEST_FILE} of=/dev/${DEVICE}s1 bs=8k > /dev/null 2>&1 && print_ok
  SAV="Y"
  echo -n "Do you want to remove ${DEST_FILE} [Y]? "
  read SAV
  if [ "${SAV}" = "" -o "${SAV}" = "Y" -o "${SAV}" = "y" ]; then
    rm -f ${DEST_FILE}
  fi
fi

if [ "${CHAIN}" = "Y" ]; then
  printf "\033[1;36mFinished!\033[0m\n"
fi

