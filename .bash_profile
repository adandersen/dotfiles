source ~/.bashrc

# install brew if not already installed
[ ! -x $(which brew) ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


if [ -f ~/.local/bin/dropbox.py ]; then
    ~/.local/bin/dropbox.py start > /dev/null
else
    echo 'dropbox not installed at ~/.local/bin/dropbox.py, download it, chmod it, and put it there'
fi

# map caps lock to esc and right alt to ctrl
# -r means file exists and is readable
[ -r ~/.Xmodmap ] && xmodmap ~/.Xmodmap 

if [ -f ~/.bash_profile_local ]; then
    source ~/.bash_profile_local
fi

[ -x "$(which zoxide)" ] && eval "$(zoxide init bash)" || echo 'no zoxide'
