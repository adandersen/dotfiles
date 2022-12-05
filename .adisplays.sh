if [ -z "$1" ]; then
    echo "Setting 2 primary monitors with laptop monitor off." &&
    xrandr \
    --dpi 108 \
    --output DP-0 --primary --mode 2560x1440 --pos 0x1120 --rotate normal \
    --output DP-1 --mode 2560x1440 --pos 2560x300 --rotate right \
    --output HDMI-0 --off \
    --output DP-2 --off
else
    echo "Setting only main monitor." &&
    xrandr \
        --dpi 208 \
        --output DP-2 --off \
        --output DP-1 --off \
        --output DP-0 --mode 3840x1600 --rate 60 --primary
fi


