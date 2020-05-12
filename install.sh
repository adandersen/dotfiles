#! /bin/bash
# assumes ubuntu
dotfiles_absolute_path="$(cd ~/.local/dotfiles && pwd)"

if [ ! "$(pwd)" == $dotfiles_absolute_path ]; then
    echo "currently in $(pwd)"
    echo "dotfiles directory needs to be in ~/.local/dotfiles to proceed"
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
    yellow "Setup dot files, hard linking in $HOME"
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
}

installAwesomeWM() {
    sudo apt install awesome
    yellow "Setup AwesomeWM config"
    mkdir -p ~/.config/awesome
    ln -f ./.config/awesome/rc.lua ~/.config/awesome/rc.lua
    ln -f ./.config/awesome/defaultCustom.lua ~/.config/awesome/defaultCustom.lua
    git clone https://github.com/streetturtle/awesome-wm-widgets.git # for battery, cpu indicators etc
    yellow "Cloning AwesomeWM code"
    mkdir -p ~/dev/3rdParty
    cd ~/dev/3rdParty
    git clone git@github.com:awesomeWM/awesome.git
}

installNeovim() {
    yellow "Setup neovim config, hard linking  ~/.config/nvim/init.vim"
    mkdir -p ~/.config/nvim
    ln -f ./.config/nvim/init.vim ~/.config/nvim/init.vim
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    echo ""
    lightcyan "Done setting up neovim!"
    lightcyan "PlugInstall, don't forget!"
    echo ""
}

installI3lockColor() {
    yellow "Setup i3lock-color (lock screen, dependency for betterlockscreen script)"
    yellow "  Copying i3lock for now, don't have i3lock-color setup"
    # TODO: get betterlockscreen to work instead
    local_bin_absolute_path="$(cd ~/.local/bin && pwd)"
    if [ ! -f "$local_bin_absolute_path/i3lock" ]; then
        sudo apt install pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev autoconf

        mkdir -p ~/.local/bin
        cd ~/.local
        git clone https://github.com/Raymo111/i3lock-color.git
        cd i3lock-color
        git tag -f "git-$(git rev-parse --short HEAD)" # build non-debug version
        autoreconf -i && ./configure && make # build with gnu auto tools

        ln -s ~/.local/i3lock-color/x86_64-pc-linux-gnu/i3lock ~/.local/bin/i3lock # make 3lock available on path
    else
        echo "i3lock already exists, not copying"
    fi
}

installNodejs() {
    # Install latest nodejs
    if [ ! -x "$(command -v node)" ]; then
        curl --fail -LSs https://install-node.now.sh/latest | sh
    fi
}

installLua() {
    sudo apt install luajit
    sudo apt install luarocks
    sudo luarocks install --server=http://luarocks.org/dev lua-lsp # language server protocol for lua
    sudo luarocks install luacheck
    sudo luarocks install Formatter
}

installApps() {
    installAwesomeWM
    installNeovim
    installI3lockColor
    installNodejs
    installLua
    yellow "Install redshift, bluelight reducer"
    sudo apt install redshift
    echo "Installing ripgrep for neovim fzf searching"
    yellow apt install ripgrep
}


linkDotfiles
installApps

