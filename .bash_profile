source ~/.bashrc

export PATH=~/.local/bin:$PATH
### XDG env vars https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# I'm mostly using the defaults...
export XDG_CONFIG_HOME=~/.config                   # personal configuration files
export XDG_DATA_HOME=~/.local/share                # personal user data
export XDG_CONFIG_DIRS=/etc/xdg                    # system config search order, XDG_CONFIG_HOME is searched first
export XDG_DATA_DIRS=/usr/local/share:/usr/share   # search order of data, earlier first, XDG_DATA_HOME precedes this
export XDG_CACHE_HOME=~/.cache                     # runtime apps non-essential user data files
export XDG_RUNTIME_DIR=~/.runtime                  # runtime apps non-essential user runtime files. Must be deleted on logout or shutdown/reboot

export KUBE_EDITOR='vim'
export EDITOR='vim'
# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.venv/lib64/*" --glob "!.git/*"' # meant for fuzzy finder in vim

if [ -f ~/.local/bin/dropbox.py ]; then
    ~/.local/bin/dropbox.py start > /dev/null
else
    echo 'dropbox not installed at ~/.local/bin/dropbox.py, download it, chmod it, and put it there'
fi

# http://rabexc.org/posts/using-ssh-agent
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent`
fi

if [ -f ~/.bash_profile_local ]; then
    source ~/.bash_profile_local
fi
