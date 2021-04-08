#! /bin/bash
# assumes ubuntu
mkdir -p ~/.config/dotfiles
mkdir -p ~/.config/i3
mkdir -p ~/.local/bin
mkdir -p ~/dev/3rdParty
dotfiles_absolute_path="$(cd ~/.config/dotfiles && pwd)"
local_bin_absolute_path="$(cd ~/.local/bin && pwd)"

if [ ! "$(pwd)" == $dotfiles_absolute_path ]; then
    echo "currently in $(pwd)"
    echo "dotfiles directory needs to be in ~/.config/dotfiles to proceed"
    exit
fi
NC='\033[0m' # no color

red() {
    RED='\033[0;31m'
    echo -e "$RED$1$NC"
}

lightcyan() {
    LIGHTCYAN='\033[1;36m'
    echo -e "$LIGHTCYAN$1$NC"
}

yellow() {
    YELLOW='\033[0;33m'
    echo -e "$YELLOW$1$NC"
}

linkDotfiles() {
    if [ ! -f ~/.ideavimrc ]; then
        yellow "Setup dot files, hard linking in $HOME"
        ln -f $dotfiles_absolute_path/.ideavimrc ~/.ideavimrc
        ln -f $dotfiles_absolute_path/.bash_profile ~/.bash_profile
        ln -f $dotfiles_absolute_path/.bashrc ~/.bashrc
        ln -f $dotfiles_absolute_path/.gitconfig ~/.gitconfig
        ln -f $dotfiles_absolute_path/.tmux.conf ~/.tmux.conf
        ln -f $dotfiles_absolute_path/.inputrc ~/.inputrc
        ln -f $dotfiles_absolute_path/.Xmodmap ~/.Xmodmap
        ln -f $dotfiles_absolute_path/.xmodmaprc ~/.xmodmaprc
        ln -f $dotfiles_absolute_path/.xsession ~/.xsession
        ln -f $dotfiles_absolute_path/i3/config ~/.config/i3/config

        source ~/.bash_profile # source in current terminal
    fi
}

installAwesomeWM() {
    if [ ! -x "$(command -v awesome)" ]; then
        sudo apt install awesome
        yellow "Setup AwesomeWM config"
        mkdir -p ~/.config/awesome
        cd ~/.config/awesome
        ln -f $dotfiles_absolute_path/.config/awesome/rc.lua ~/.config/awesome/rc.lua
        ln -f $dotfiles_absolute_path/.config/awesome/defaultCustom.lua ~/.config/awesome/defaultCustom.lua
        git clone https://github.com/streetturtle/awesome-wm-widgets.git # for battery, cpu indicators etc
        git clone https://github.com/lcpz/lain.git ~/.config/awesome/lain # other widgets, layouts etc

        yellow "Cloning AwesomeWM code"
        cd ~/dev/3rdParty
        git clone git@github.com:awesomeWM/awesome.git
    fi
}

installNeovim() {
    if [ ! -x "$(command -v nvim)" ]; then
        yellow "Setup neovim config, hard linking  ~/.config/nvim/init.vim"
        mkdir -p ~/.config/nvim
        ln -f $dotfiles_absolute_path/.config/nvim/init.vim ~/.config/nvim/init.vim
        curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

        echo ""
        lightcyan "Done setting up neovim!"
        lightcyan "PlugInstall, don't forget!"
        echo ""
    fi
}

installI3lockColor() {
    # TODO: get betterlockscreen to work instead
    if [ ! -f "$local_bin_absolute_path/i3lock" ]; then
        yellow "Setup i3lock-color (lock screen, dependency for betterlockscreen script)"
        yellow "  Copying i3lock for now, don't have i3lock-color setup"
        sudo apt install pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev autoconf

        cd ~/.local
        git clone https://github.com/Raymo111/i3lock-color.git
        cd i3lock-color
        git tag -f "git-$(git rev-parse --short HEAD)" # build non-debug version
        autoreconf -i && ./configure && make # build with gnu auto tools

        ln -s ~/.local/i3lock-color/x86_64-pc-linux-gnu/i3lock ~/.local/bin/i3lock # make 3lock available on path
    fi
}

installNodejs() {
    if [ ! -x "$(command -v node)" ]; then
        curl --fail -LSs https://install-node.now.sh/latest | sh
    fi
}

installLua() {
    if [ ! -x "$(command -v luajit)" ]; then
        yello "Install luajit"
        sudo apt install luajit
        sudo apt install luarocks
        sudo luarocks install --server=http://luarocks.org/dev lua-lsp # language server protocol for lua
        sudo luarocks install luacheck
        sudo luarocks install Formatter
    fi
}

installKitty() {
    if [ ! -x "$(command -v kitty)" ]; then
        yello "Install kitty, terminal emulator"
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
        ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/
    fi
}

installUtilities() {
    if [ ! -x "$(command -v redshift)" ]; then
        yellow "Install redshift, bluelight reducer"
        sudo apt install redshift
    fi
    if [ ! -x "$(command -v rg)" ]; then
        yellow "Installing ripgrep for neovim fzf searching"
        sudo apt install ripgrep
    fi
}

installI3() {
    if [ ! -x "$(command -v i3" ]; then
        sudo apt install i3 i3status dmenu i3lock xbacklight feh conky
    fi
}

installApps() {
    installKitty
    installLua
    #installAwesomeWM
    installNeovim
    installI3lockColor
    installNodejs
    installUtilities
    installI3
}


linkDotfiles
installApps

