# This file is needed when using a login manager such as gdm with fedora, as gdm doesn't invoke .bash_profile by default. 
# See http://mywiki.wooledge.org/DotFiles in the "X sessions" area and search for gdm.

# -r means file exists and is readable
#[ -r ~/.bash_profile ] && source ~/.bash_profile

# set keyboard delay to 150 milliseconds and keyboard rate to 60 something...
# only works under X, not wayland unfortunately
# xset r rate 150 60
# run this on gnome under wayland instead
# gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 10
# gsettings set org.gnome.desktop.peripherals.keyboard delay 150

# remap caps lock to escape and right alt to ctrl
[ -r ~/.Xmodmap ] && xmodmap ~/.Xmodmap 
