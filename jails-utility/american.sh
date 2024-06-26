#!/bin/sh
JAIL_PATH_0=/usr/local/jails

fn_infra_struct() {
	if [ -e $JAIL_ATH_0 ]; then
		echo 'jails dir OK'
	else
		mkdir -p $JAIL_PATH_0/{conteiners,templates,media}
		
		echo 'dir $JAIL_PATH_0 criado'
	fi 
}
fn_infra_struct;
