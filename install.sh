#! /bin/bash
# assumes ubuntu

if [ ! "$(pwd)" == "~/.local/dotfiles" ]; then
    exit
fi

echo "Setup neovim config, hard linking  ~/.config/nvim/init.vim"
mkdir -p ~/.config/nvim
ln -f ./.config/nvim/init.vim ~/.config/nvim/init.vim

echo "Setup other dot files, hard linking in $HOME"
ln ./.ideavimrc ../.ideavimrc
ln ./.Xmodmap ../.Xmodmap
ln ./.bash_profile ../.bash_profile
ln ./.bashrc ../.bashrc
ln ./.gitconfig ../.gitconfig
ln ./.tmux.conf ../.tmux.conf
ln ./.inputrc ../.inputrc
ln ./.xmodmaprc ../.xmodmaprc

echo "Setup AwesomeWM config"
mkdir -p ~/.config
ln -s ~/.local/dotfiles/awesome ~/.config/awesome

echo "Setup i3lock-color (lock screen, dependency for betterlockscreen script)"
sudo apt install pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev

mkdir -p ~/.local
cd ~/.local
git clone https://github.com/Raymo111/i3lock-color.git
cd i3lock-color
git tag -f "git-$(git rev-parse --short HEAD)" # build non-debug version
autoreconf -i && ./configure && make # build with gnu auto tools
ln -s ~/.local/i3lock-color/x86_64-pc-linux-gnu/i3lock ~/.local/bin/i3lock # make 3lock available on path
# TODO: get betterlockscreen to work instead


