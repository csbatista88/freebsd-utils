#!/bin/sh

. ./config.sh

MODULES="ipfw4 ipfw6 ipsec netgraph usb"
KERN_FILE="/usr/src/sys/i386/conf/${KERNEL_FILE}"

ask_for_ipfw4() {
	echo ""											>> ${KERN_FILE}
	echo "# Firewall & nat"							>> ${KERN_FILE}
	echo "options	IPFIREWALL" 					>> ${KERN_FILE}
	echo "options	IPFIREWALL_FORWARD" 			>> ${KERN_FILE}
	echo "options	IPFIREWALL_DEFAULT_TO_ACCEPT" 	>> ${KERN_FILE}
	echo "options	IPFIREWALL_VERBOSE" 			>> ${KERN_FILE}    
	echo "options	IPFIREWALL_VERBOSE_LIMIT=0" 	>> ${KERN_FILE}  
	echo "options	IPDIVERT" 						>> ${KERN_FILE}       
	echo "options	DUMMYNET" 						>> ${KERN_FILE}
	echo "options	BRIDGE" 						>> ${KERN_FILE}
	echo "options	HZ=1000"						>> ${KERN_FILE}
	if [ "${RELEASE}" = "4" ]; then	
		echo "options	IPFW2" 						>> ${KERN_FILE}
	fi
}

ask_for_ipfw6() {
	echo ""											>> ${KERN_FILE}
	echo "# IPv6"									>> ${KERN_FILE}
		if [ "${INET6_PRESENT}" = "" ]; then
			echo "options  INET6" 					>> ${KERN_FILE}
	fi
	echo "options  IPV6FIREWALL" 					>> ${KERN_FILE}
	echo "options  IPV6FIREWALL_DEFAULT_TO_ACCEPT" 	>> ${KERN_FILE}
}

ask_for_ipsec() {
	echo "" 										>> ${KERN_FILE}
	echo "# IPSEC support" 							>> ${KERN_FILE}
	echo "options  IPSEC" 							>> ${KERN_FILE}
	echo "options  IPSEC_ESP" 						>> ${KERN_FILE}
	echo "" 										>> ${KERN_FILE}
}

ask_for_netgraph() {
	echo ""											>> ${KERN_FILE}
	echo "# NETGRAPH support" 						>> ${KERN_FILE}
	echo "options  NETGRAPH" 						>> ${KERN_FILE}
	echo "options  NETGRAPH_ASYNC" 					>> ${KERN_FILE}
	echo "options  NETGRAPH_BPF" 					>> ${KERN_FILE}
	echo "options  NETGRAPH_CISCO" 					>> ${KERN_FILE}
	echo "options  NETGRAPH_ECHO" 					>> ${KERN_FILE}
	echo "options  NETGRAPH_ETHER" 					>> ${KERN_FILE}
	echo "options  NETGRAPH_FRAME_RELAY" 			>> ${KERN_FILE}
	echo "options  NETGRAPH_HOLE" 					>> ${KERN_FILE}
	echo "options  NETGRAPH_IFACE" 					>> ${KERN_FILE}
	echo "options  NETGRAPH_KSOCKET" 				>> ${KERN_FILE}
	echo "options  NETGRAPH_PPP" 					>> ${KERN_FILE}
	echo "options  NETGRAPH_PPPOE" 					>> ${KERN_FILE}
	echo "options  NETGRAPH_PPTPGRE" 				>> ${KERN_FILE}
	echo "options  NETGRAPH_RFC1490" 				>> ${KERN_FILE}
	echo "options  NETGRAPH_L2TP" 					>> ${KERN_FILE}
	echo "options  NETGRAPH_LMI" 					>> ${KERN_FILE}
	echo "options  NETGRAPH_ONE2MANY" 				>> ${KERN_FILE}
	echo "options  NETGRAPH_MPPC_ENCRYPTION" 		>> ${KERN_FILE}
	echo "options  NETGRAPH_SOCKET" 				>> ${KERN_FILE}
	echo "options  NETGRAPH_TEE" 					>> ${KERN_FILE}
	echo "options  NETGRAPH_TTY" 					>> ${KERN_FILE}
	echo "options  NETGRAPH_UI" 					>> ${KERN_FILE}
	echo "options  NETGRAPH_VJC" 					>> ${KERN_FILE}
	if [ ! "${RELEASE}" = "4" ]; then	
		echo "options  NETGRAPH_BRIDGE" 			>> ${KERN_FILE}
		echo "options  NETGRAPH_GIF" 				>> ${KERN_FILE}
		echo "options  NETGRAPH_GIF_DEMUX" 			>> ${KERN_FILE}
		echo "options  NETGRAPH_IP_INPUT" 			>> ${KERN_FILE}
		echo "options  NETGRAPH_SPLIT" 				>> ${KERN_FILE}
	fi 	
}

ask_for_usb() {
	echo ""											>> ${KERN_FILE}
	echo "# USB support" 							>> ${KERN_FILE}
	echo "device    ehci" 							>> ${KERN_FILE}
	echo "device    ohci" 							>> ${KERN_FILE}
	echo "device    uhci" 							>> ${KERN_FILE}
	echo "device    usb" 							>> ${KERN_FILE}
	echo "device    ugen" 							>> ${KERN_FILE}
	echo "device    uhid" 							>> ${KERN_FILE}
	echo "device    ukbd" 							>> ${KERN_FILE}
	echo "device    umass" 							>> ${KERN_FILE}
	echo "device    ums" 							>> ${KERN_FILE}
	echo "# SCSI support for umass" 				>> ${KERN_FILE}
	echo "device    scbus" 							>> ${KERN_FILE}
	echo "device    da" 							>> ${KERN_FILE}
}

for MODULE in ${MODULES}
do
	echo -n "Do you want ${MODULE} in your kernel (y/n) [y]: "
	read ANSWER
	echo -n Adding module: ${MODULE} 
		if [ "${ANSWER}" = "" -o "${ANSWER}" = "y" -o "${ANSWER}" = "Y" ]; then
    		ask_for_${MODULE}
			print_ok
		else
			print_ko
		fi	  
done
