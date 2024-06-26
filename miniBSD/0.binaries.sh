#!/bin/sh

. ./config.sh
if [ "${CHAIN}" = "Y" ]; then
  printf "\033[1;36m0.binaries.sh\033[0m\n"
fi

export __MAKE_CONF=${START_PATH}/myfiles/conf/make.conf

if [ "$1" = "NOCLEAN" ]; then
  NOCLEAN="yes"
fi

if [ "${RELEASE}" = "4" ]; then
  CHFLAGS_BIN="/usr/bin/chflags"
else
  CHFLAGS_BIN="/bin/chflags"
fi

if [ -d "${JAIL_DIR}" ]; then
  ANSWER="y"
  if [ ! "${CHAIN}" = "Y" ]; then
    echo -n "${JAIL_DIR} found. Remove all files? [y]: "
    read ANSWER
  fi
  if [ "${ANSWER}" = ""  -o "${ANSWER}" = "Y" -o "${ANSWER}" = "y" ]; then
    echo -n "Removing old ${JAIL_DIR}... " 
    ${CHFLAGS_BIN} -R noschg ${JAIL_DIR} > /dev/null 2>&1 && rm -rf ${JAIL_DIR} && print_ok
  fi
fi

echo -n "Creating jail for miniBSD... "
mkdir -p ${JAIL_DIR} > /dev/null 2>&1 && print_ok

echo -n "Creating mtree..." 
mtree -deU -f /usr/src/etc/mtree/BSD.root.dist -p ${JAIL_DIR} 		> /dev/null 2>&1 && \
mtree -deU -f /usr/src/etc/mtree/BSD.usr.dist -p ${JAIL_DIR}/usr/ 	> /dev/null 2>&1 && \
mtree -deU -f /usr/src/etc/mtree/BSD.var.dist -p ${JAIL_DIR}/var/ 	> /dev/null 2>&1 &&    print_ok

#Bug? These dirs is not been created from BSD.usr.dist, 
#so, we have to create it manually
mkdir ${JAIL_DIR}/usr/share/nls/en_US.US-ASCII 						> /dev/null 2>&1
mkdir ${JAIL_DIR}/usr/share/nls/ja_JP.EUC 							> /dev/null 2>&1

FILES_LIST="minibsd_${RELEASE}.files"

for i in ${BIN_DIR}
do
  IS_GNU=`echo $i | cut -c 1-3`
  IS_SECURE=`echo $i | cut -c 1-6`
  echo "Making in ${i}... "
  cd /usr/src/${i}
  for j in `ls`
  do
    #Set the default path
    TO_COMPILE=`grep "^${i}/${j}" ${START_PATH}/${FILES_LIST}`
    
    if [ "${IS_GNU}" = "gnu" ]; then
      RIGHT_PATH=`echo $i | awk '{print substr($0,5,length($0)-4);}'`
      TO_COMPILE=`grep "^${RIGHT_PATH}/${j}" ${START_PATH}/${FILES_LIST}`
    fi
    if [ "${IS_SECURE}" = "secure" ]; then
      RIGHT_PATH=`echo $i | awk '{print substr($0,8,length($0)-7);}'`
      TO_COMPILE=`grep "^${RIGHT_PATH}/${j}" ${START_PATH}/${FILES_LIST}`
    fi
    if [ "${TO_COMPILE}" != "" ]; then
      printf "\tCompiling ${i}/${j}..." 
      cd ${j}
      if [ "${NOCLEAN}" != "yes" ]; then
        make clean 												> /dev/null  2>&1
      fi
      make 														> /dev/null 2>&1 && \
      make install DESTDIR=${JAIL_DIR} 							> /dev/null 2>&1 && print_ok
      cd ..
    fi
  done
done

echo -n "Making /boot stuff..."
cd /sys/boot
make clean 														> /dev/null 2>&1 && \
make 															> /dev/null 2>&1 && \
make install DESTDIR=${JAIL_DIR} 								> /dev/null 2>&1 && print_ok
cd ${START_PATH} 

if [ "${CHAIN}" = "Y" ]; then
  sh 1.kernel.sh
fi
