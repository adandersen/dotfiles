#! /bin/bash

if [ ! "$(pwd)" == "$HOME/.dotfiles" ]; then
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
