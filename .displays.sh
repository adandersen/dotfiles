echo 'setting frame buffer' &&
	xrandr --fb 17920x2880 &&
	echo 'setting laptop monitor' &&
	xrandr --output eDP-1-1 --mode 3840x2160 --rate 60 --primary &&
	echo 'setting left monitor' &&
	xrandr --output DP-1 --mode 2560x1440 --scale-from 5120x2880 --panning 5120x2880+3840+720 --right-of eDP-1-1 &&
	echo 'setting right monitor' &&
	xrandr --output DP-0 --mode 2560x1440 --scale-from 5120x2880 --panning 5120x2880+8960+720 --right-of DP-1 &&
	echo 'setting global scaling to 2x' &&
	gsettings set org.gnome.desktop.interface scaling-factor 2


