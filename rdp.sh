#!/bin/sh
### login@domain ###
RDP_LOGIN="$1"
### ip or name ###
RDP_HOST="$2"
### resolution WxH ###
RDP_SIZE="1440x880"
exec xfreerdp /u:$RDP_LOGIN /v:$RDP_HOST /from-stdin \
	/sound:sys:oss /microphone:sys:oss,format:1 \
	/clipboard /dynamic-resolution /size:$RDP_SIZE
