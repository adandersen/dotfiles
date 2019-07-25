if [ -z "$1" ]; then
	echo echo 'setting frame buffer' &&
		xrandr --fb 12880x2880 &&
		echo 'setting laptop monitor' &&
		xrandr --output eDP-1-1 --mode 3840x2160 --rate 60 --primary &&
		echo 'setting left monitor' &&
		xrandr --output DP-1 --mode 2560x1440 --scale-from 5120x2880 --panning 5120x2880+3840+0 --right-of eDP-1-1 &&
		echo 'setting right monitor' &&
		xrandr --output DP-0 --mode 2560x1440 --scale-from 5120x2880 --panning 5120x2880+8960+0 --right-of DP-1 &&
		echo 'setting global scaling to 2x' &&
		gsettings set org.gnome.desktop.interface scaling-factor 2
else
	echo 'setting frame buffer' &&
		xrandr --output DP-0 --off &&
		xrandr --output DP-1 --off &&
		xrandr --fb 3480x2160 &&
		echo 'setting laptop monitor' &&
		xrandr --output eDP-1-1 --mode 3840x2160 --rate 60 --primary &&
		echo 'setting global scaling to 2x' &&
		gsettings set org.gnome.desktop.interface scaling-factor 2
fi


