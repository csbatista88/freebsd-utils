#!/bin/sh

. config.sh

if [ "$1" = "" ]; then 

	echo "Error: Some mandatory params are missing [INPUT FILE]"
	exit 5
fi 


FILES=`cat $1 | awk '{if (substr($0,0,1)=="#" || $0=="") getline;
                    else
                      print $0;}'`


for file in $FILES
do

  FILE=`echo $file | awk -F ":" '{print $1}'`
  LINK=`echo $file | awk -F ":" '{print $2}'`
  DIR=`echo ${FILE} | awk -F "/" '{print substr($0,0,length($0)-length($(NF)));}'`



  if [ ! -d "${JAIL_DIR}/${DIR}" ]; then
    	mkdir -p ${JAIL_DIR}/${DIR} 
  fi


  if [ -e /${FILE} ]; then
 
  	echo -n "Copying ${FILE}" && /usr/bin/tput ch 54
  	cp -p /${FILE} ${JAIL_DIR}/${FILE} >/dev/null 2>&1
    printf "\033[1;36m[OK]\033[0m\n"

  else 

	echo ""
	echo "Warning. Missing FILE: /${FILE}"
	echo ""

  fi 


  if [ "${LINK}" != "" ]; then
    
	DIR=`echo ${LINK} | awk -F "/" '{print substr($0,0,length($0)-length($(NF)));}'`

    	if [ ! -d "${JAIL_DIR}/${DIR}" ]; then
      		mkdir -p ${JAIL_DIR}/${DIR}
    	fi
 
	rm -rf ${JAIL_DIR}/${LINK}  	
	echo "Linking ${JAIL_DIR}/${FILE} to ${JAIL_DIR}/${LINK}" 
	ln ${JAIL_DIR}/${FILE} ${JAIL_DIR}/${LINK}
  fi
done

