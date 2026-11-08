export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="/usr/bin:$PATH"
export VISUAL=nvim
export EDITOR=nvim
export LESS="-R"
export PATH="$HOME/.local/share/yabridge:$PATH"
# .bashrc

# extend bash history
HISTSIZE=10000     # commands kept in memory for the current session
HISTFILESIZE=10000 # lines kept in ~/.bash_history

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

alias autocalc_helper="/home/druidpwnz/Documents/autocalc_helper/main.py"
alias ssh_homeserver="ssh druiduser@192.168.50.70"
alias smb_mount="/home/druidpwnz/mount_smb.sh"
alias ff="fastfetch"
alias cl="clean"
alias vim="nvim"
alias src="source .venv/bin/activate"
alias cl="clear"
alias ll="ls -la"
alias dot='git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc
