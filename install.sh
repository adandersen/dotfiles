#! /bin/bash
# assumes ubuntu
absolute_path="$(cd ~/.local/dotfiles && pwd)"

if [ ! "$(pwd)" == $absolute_path ]; then
    echo "currently in $(pwd)"
    echo "dotfiles directory needs to be in ~/.local/dotfiles to proceed"
    exit
fi

echo "Setup neovim config, hard linking  ~/.config/nvim/init.vim"
mkdir -p ~/.config/nvim
ln -f ./.config/nvim/init.vim ~/.config/nvim/init.vim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo ""
echo "Done setting up neovim!"
echo "PlugInstall, don't forget!"
echo ""

echo "Setup other dot files, hard linking in $HOME"
ln -f ./.ideavimrc ~/.ideavimrc
ln -f ./.bash_profile ~/.bash_profile
ln -f ./.bashrc ~/.bashrc
ln -f ./.gitconfig ~/.gitconfig
ln -f ./.tmux.conf ~/.tmux.conf
ln -f ./.inputrc ~/.inputrc
ln -f ./.Xmodmap ~/.Xmodmap
ln -f ./.xmodmaprc ~/.xmodmaprc
ln -f ./.xsession ~/.xsession

source ~/.bash_profile # source in current terminal

echo "Setup AwesomeWM config"
mkdir -p ~/.config/awesome
ln -f ./.config/awesome/rc.lua ~/.config/awesome/rc.lua
ln -f ./.config/awesome/defaultCustom.lua ~/.config/awesome/defaultCustom.lua

echo "Setup i3lock-color (lock screen, dependency for betterlockscreen script)"
sudo apt install pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev autoconf

mkdir -p ~/.local/bin
cd ~/.local
git clone https://github.com/Raymo111/i3lock-color.git
cd i3lock-color
git tag -f "git-$(git rev-parse --short HEAD)" # build non-debug version
autoreconf -i && ./configure && make # build with gnu auto tools
ln -s ~/.local/i3lock-color/x86_64-pc-linux-gnu/i3lock ~/.local/bin/i3lock # make 3lock available on path
# TODO: get betterlockscreen to work instead


