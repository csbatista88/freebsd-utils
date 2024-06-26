#!/bin/sh 

. config.sh
if [ "${CHAIN}" = "Y" ]; then
  printf "\033[1;36m5.last_tuning.sh\033[0m\n"
fi
  

cd ${JAIL_DIR}

if [ "${RELEASE}" = "4" ]; then
  KERNEL_PATH="${JAIL_DIR}/"
else
  KERNEL_PATH="${JAIL_DIR}/boot/kernel/"
fi

if [ -f "${KERNEL_PATH}kernel.gz" ]; then 
  chflags noschg ${KERNEL_PATH}kernel.gz
  echo -n "Removing an old gzip kernel ..."
  rm -f ${KERNEL_PATH}kernel.gz >/dev/null 2>&1 && print_ok
fi

if [ -f "${KERNEL_PATH}kernel" ]; then 

	echo -n "Removing schg flag on kernel..." && chflags noschg ${KERNEL_PATH}kernel && print_ok

	echo "Stripping and compressing kernel with gzip... " 
	echo ""

	echo 	"Do you want to strip the kernel ? " 
	echo -n "Doing so something will not work anymore (es. top) [n] "
	read ANSWER
	if [ "${ANSWER}" = "Y" -o "${ANSWER}" = "y" ]; then
		echo -n "Stripping ... " && strip ${KERNEL_PATH}kernel && print_ok 
	fi 

	echo    "Do you want to gzip the kernel ? "
	echo -n "This saves 50% of the kernel size [y] "
	read ANSWER
	if [ "${ANSWER}" = "Y" -o "${ANSWER}" = "y" -o "${ANSWER}" = "" ]; then
		echo -n "Gzipping ... " && gzip -9 ${KERNEL_PATH}kernel && print_ok
	fi 

  	echo -n "Setting schg flag on the modified kernel..." 
	if [ -f "${KERNEL_PATH}kernel.gz" ]; then 
		chflags schg ${KERNEL_PATH}kernel.gz && print_ok
	else
  		chflags schg ${KERNEL_PATH}kernel && print_ok
	fi

else

	echo "kernel is missing. Please rerun 1.kernel.sh"
	exit 1

fi

echo -n "Removing unused directories... "
UNUSED_DIRS="zoneinfo games sendmail info examples isdn man doc calendar mk me nls tmac tabset groff_font dict locale syscons skel pcvt"
for UNUSED_DIR in ${UNUSED_DIRS} ; do
    rm -rf ${JAIL_DIR}/usr/share/${UNUSED_DIR}
done
print_ok

cd ${START_PATH}
if [ "${CHAIN}" = "Y" ]; then
  sh 6.create_img.sh
fi
