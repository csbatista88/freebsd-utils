umask 22
set path = (/sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin)

setenv	EDITOR	vi
setenv	PAGER	more

if ($?prompt) then
	set filec
	set prompt="%n@%m:%~%# "
endif
