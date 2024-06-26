#!/bin/sh 

. ./config.sh

tempfile=`/usr/bin/mktemp -t checklist`

menu() {
    dialog --title "miniBSD Main Menu" \
	--menu "Welcome to the miniBSD installation and configuration tool. Please \
	select one of the options below by using the arrow keys or typing the \
	first character of the option name you're interested in. Invoke an \
	option with [SPACE] or [ENTER]. To exit, use [TAB] to move to Exit." 22 73 11 \
      binaries "Create a new miniBSD jail and binaries" \
    	kernel "Build & Install Kernel" \
    	libs "Search & Install required libraries" \
    	etc "Copy /etc files" \
    	custom "Copy custom files" \
      tuning "Last tuning commands" \
    	image "Install miniBSD" \
    	iso "Build Iso - Create .iso file" \
    	Exit "Quit" \
    2> $tempfile

    result=`cat $tempfile`
    
    case ${result} in
    
      binaries)
      cd $START_PATH && sh 0.binaries.sh
      ;;
      kernel)
      cd $START_PATH && sh 1.kernel.sh
      ;;
      libs)
      cd $START_PATH && sh 2.libs_devs.sh
      ;;
      etc)
      cd $START_PATH && sh 3.populating_etc.sh
      ;;
      custom)
      cd $START_PATH && sh 4.custom_files.sh
      ;;
      tuning)
      cd $START_PATH && sh 5.last_tuning.sh
      ;;
      image)
      cd $START_PATH && sh 6.create_img.sh
      ;;
      iso)
      cd $START_PATH && sh 8.mkiso.sh
      ;;
      Exit)
      exit 0
      ;;
      *)
      exit 1
      ;;      
    esac
    menu        
}
menu
