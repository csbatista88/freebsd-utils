#!/bin/sh

. ./config.sh
if [ "${CHAIN}" = "Y" ]; then
  printf "\033[1;36m3.populating_etc.sh\033[0m\n"
fi

echo -n "Copying etc files... " 
sh ./mkmini.sh minibsd_etc_${RELEASE}.files > /dev/null 2>&1 && print_ok

echo -n "Copying custom config files... " 
if [ -f ./myfiles/conf/ttys ]; then
  cp ./myfiles/conf/ttys ${JAIL_DIR}/etc > /dev/null 2>&1
fi
if [ -f ./myfiles/conf/sshd_config ]; then
  cp ./myfiles/conf/sshd_config ${JAIL_DIR}/etc/ssh > /dev/null 2>&1
  fi
print_ok

echo -n "Creating a new pair of ssh keys... " 
[ -f ${JAIL_DIR}/etc/ssh/ssh_host_key ] && rm ${JAIL_DIR}/etc/ssh/ssh_host_key
/usr/bin/ssh-keygen -t rsa1 -N "" -f ${JAIL_DIR}/etc/ssh/ssh_host_key > /dev/null 2>&1
[ -f ${JAIL_DIR}/etc/ssh/ssh_host_rsa_key ] && rm ${JAIL_DIR}/etc/ssh/ssh_host_rsa_key
/usr/bin/ssh-keygen -t rsa -N "" -f ${JAIL_DIR}/etc/ssh/ssh_host_rsa_key > /dev/null 2>&1
[ -f ${JAIL_DIR}/etc/ssh/ssh_host_dsa_key ] && rm ${JAIL_DIR}/etc/ssh/ssh_host_dsa_key
/usr/bin/ssh-keygen -t dsa -N "" -f ${JAIL_DIR}/etc/ssh/ssh_host_dsa_key > /dev/null 2>&1
print_ok

echo -n "Copying the default passwd file... " 
cp ./myfiles/conf/master.passwd ${JAIL_DIR}/etc
cp ./myfiles/conf/passwd ${JAIL_DIR}/etc
cp ./myfiles/conf/pwd.db ${JAIL_DIR}/etc
cp ./myfiles/conf/spwd.db ${JAIL_DIR}/etc
print_ok

cd ${START_PATH}
if [ "${CHAIN}" = "Y" ]; then 
  sh 4.custom_files.sh
fi

