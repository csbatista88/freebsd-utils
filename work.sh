sysctl hw.snd.default_unit=2
setxkbmap us intl
xmodmap -e "keycode 94 = grave asciitilde"
xmodmap -e "keycode 94 = dead_grave dead_tilde"
backlight -f /dev/backlight/backlight0 50
sysctl dev.asmc.0.light.control=50
