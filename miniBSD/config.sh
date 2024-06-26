#Definition file for miniBSD scripts

#!/bin/sh

if [ "`id -u`" != "0" ]; then
  echo "Sorry, this must be done as root."
  exit 1
fi

TERM=cons25
export TERM

#This variable allows to set the default editor used to edit
#the kernel file.
EDITOR=vi
BIN_DIR="lib bin sbin usr.bin usr.sbin libexec gnu/usr.bin secure/usr.bin secure/usr.sbin"

#This variable allows to choose the default device used.
DEF_DEV="da0"
DEST_FILE="${HOME}/minibsd.bin"
ISO_FILE="${HOME}/minibsd.iso"
JAIL_DIR="/usr/local/miniBSD"
DEST_DIR="/mnt/miniBSD"
MOUNT_POINT="${DEST_DIR}"
START_PATH=`pwd`

#This variable redirects to null kernel compilation output
KERNEL_SILENT="Y"
KERNEL_FILE="MINIBSD"

OS=`uname -r`
case ${OS} in

	4*) 
		RELEASE=4
	;;
	5*) 
		RELEASE=5
	;;
	6*)
		RELEASE=6
	;;
	*) 
		RELEASE="UNSUPPORTED"
esac

#This variable allows to execute all the scripts in a chain.
#the user has only to invoke the first one (0.binaries.sh),
#and 0.binaries.sh calls 1.kernel.sh and so on.
CHAIN="N"

print_ok () {
	/usr/bin/tput ch 54
	printf "\033[1;36m[ok]\033[0m\n"
}

print_ko () {
	/usr/bin/tput ch 54
	printf "\033[1;31m[ko]\033[0m\n"
}
