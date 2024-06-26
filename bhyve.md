# creating vm
## creating wired
ifconfig tap0 create
sysctl net.link.tap.up_on_open=1

ifconfig bridge0 create
ifconfig bridge0 addm igb0 addm tap0
ifconfig bridge0 up

## creating disk

truncate -s 16G guest.img

## download iso 
fetch https://download.freebsd.org/releases/ISO-IMAGES/13.1/FreeBSD-13.1-RELEASE-amd64-bootonly.iso

or

fetch https://cdn.openbsd.org/pub/OpenBSD/7.4/amd64/miniroot74.img

## up and install
sh /usr/share/examples/bhyve/vmrun.sh -c 1 -m 1024M -t tap0 -d guest.img -i -I FreeBSD-13.1-RELEASE-amd64-bootonly.iso guestname

## enjoy


sh /usr/share/examples/bhyve/vmrun.sh -c 4 -m 1024M -t tap0 -d guest.img guestname

