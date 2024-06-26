#!/bin/sh

. config.sh
if [ "${CHAIN}" = "Y" ]; then
  printf "\033[1;36m4.custom_files.sh\033[0m\n"
fi
  

if [ "${RELEASE}" = "4" ]; then
  cd ${START_PATH}/myfiles/custom_files/4branch
else
  cd ${START_PATH}/myfiles/custom_files/5branch
fi

echo -n "Copying custom tuned files... " 
find . -depth -print | grep -v CVS | cpio -pvudm ${JAIL_DIR} > /dev/null 2>&1 && print_ok


cd ${START_PATH}
if [ "${CHAIN}" = "Y" ]; then
  sh 5.last_tuning.sh
fi

