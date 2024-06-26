#!/bin/sh

. ./config.sh
if [ "${CHAIN}" = "Y" ]; then 
  printf "\033[1;36m2.libs_devs.sh\033[0m\n"
fi

cd ${START_PATH}
sh ./mklibs.sh  > ./minibsd.libs && \
sh ./mkmini.sh minibsd.libs && \
cp -p /usr/lib/pam* ${JAIL_DIR}/usr/lib
rm ./minibsd.libs

echo ""

if [ "${RELEASE}" = "4" ]; then
  echo "FIXME: Creating static entres in /dev!"
  echo -n "Making devices..." && /usr/bin/tput ch 54
  cd ${JAIL_DIR}
  cp -rp /dev/MAKEDEV ${JAIL_DIR}/dev/ 
  cd dev && sh MAKEDEV all && \
  sh MAKEDEV ad0s1a && sh MAKEDEV ad0s2a && \
  sh MAKEDEV ad0s3a && sh MAKEDEV ad0s4a && print_ok
fi

cd ${START_PATH}
if [ "${CHAIN}" = "Y" ]; then 
  sh 3.populating_etc.sh
fi

