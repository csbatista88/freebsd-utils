#!/bin/sh

. ./config.sh
if [ "${CHAIN}" = "Y" ]; then
    printf "\033[1;36m1.kernel.sh\033[0m\n"
fi

export __MAKE_CONF=${START_PATH}/myfiles/conf/make.conf 

echo -n "Preparing ${KERNEL_FILE} conf file" && print_ok
echo ""

if [ "$RELEASE" = "4" ]; then
  cp ./myfiles/conf/${KERNEL_FILE} /usr/src/sys/i386/conf/
else
  #Copying loader.conf 
  cp /boot/defaults/loader.conf ${JAIL_DIR}/boot/defaults/
  touch ${JAIL_DIR}/boot/loader.conf
  cp ./myfiles/conf/${KERNEL_FILE}.5 /usr/src/sys/i386/conf/${KERNEL_FILE}
  cp /usr/src/sys/i386/conf/GENERIC.hints ${JAIL_DIR}/boot/device.hints
fi

ANSWER=""
echo "Do you want to add kernel features"
echo -n "answering to simple questions [y]? "
read ANSWER
if [ "${ANSWER}" = "Y" -o "${ANSWER}" = "y" -o "${ANSWER}" = "" ]; then
	sh 9.custom_kernel.sh
fi

ANSWER="Y"
if [ ! "${CHAIN}" = "Y" ]; then
  echo -n "Do you want to edit/check the kernel file? [y]: "
  read ANSWER
fi
if [ "${ANSWER}" = "Y" -o "${ANSWER}" = "y" -o "${ANSWER}" = "" ]; then
	${EDITOR} /usr/src/sys/i386/conf/${KERNEL_FILE}
fi 

echo ""

if [ "${NOCLEAN}" = "yes" ]; then
    cd /usr/src && make kernel DESTDIR=${JAIL_DIR} -DNOCLEAN
else
    if [ "${KERNEL_SILENT}" = "Y" ]; then
    	echo "Actually the kernel compilation is done in SILENT mode."
		echo "If you want to check the building process"
		echo "you should change KERNEL_SILENT to 'N' in config.sh"
		echo ""
		echo "The kernel compilation could take some minutes"
		echo ""
		echo -n "Compiling kernel ... " 
		cd /usr/src && make kernel KERNCONF=${KERNEL_FILE} DESTDIR=${JAIL_DIR} > /dev/null 2>&1
    else
    	echo "Actually the kernel compilation is done in VERBOSE mode."
		echo "If you don't want to check the building process"
		echo "you should change KERNEL_SILENT to 'Y' in config.sh"
		echo "The kernel compilation could take some minutes"
		echo ""
		echo -n "Press RETURN to start " && read ANSWER
    	cd /usr/src && make kernel KERNCONF=${KERNEL_FILE} DESTDIR=${JAIL_DIR}
		echo -n "Compiling kernel ... " 
    fi
fi
print_ok

#Removing old kernel
if [ "${RELEASE}" = "4" ]; then
    rm -rf ${JAIL_DIR}/modules.old
else
    rm -rf ${JAIL_DIR}/boot/kernel.old
fi
rm -rf ${JAIL_DIR}/boot/loader.old

cd ${START_PATH}
if [ "${CHAIN}" = "Y" ]; then
    sh 2.libs_devs.sh
fi
