#! /bin/sh

# echo "Sourcing .profile"

export HISTFILE=~/.history
export HISTSIZE=10000

# if hash "xset" 2> /dev/null; then
#     xset +fp /usr/share/fonts/local
#     xset fp rehash
# fi

if [ -e "$BSPWM_TREE" ] ; then
    bspc restore -T "$BSPWM_TREE" -H "$BSPWM_HISTORY" -S "$BSPWM_STACK"
    rm "$BSPWM_TREE" "$BSPWM_HISTORY" "$BSPWM_STACK"
fi

export PATH='/bin:/sbin':"$PATH"
export PATH=$HOME/Scripts:$HOME/seahawk/bin:$PATH:/opt/java/bin:$HOME/.cargo/bin

if hash nvim 2> /dev/null; then
    export VISUAL="nvim"
elif hash vim 2> /dev/null; then
    export VISUAL="vim"
else
    export VISUAL="vi"
fi

if [ "$VISUAL" = "nvim" ]; then
    export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
    if [ -e /tmp/nvimsocket ]; then
        echo "found socket"
        export VISUAL='nvr -cc vsplit -s'
    fi
    export VIMCONFIG=~/.config/nvim
    export VIMDATA=~/.local/share/nvim
else
    export VIMCONFIG=~/.vim
    export VIMDATA=~/.vim
fi

export LC_ALL="C"
# colorful man pages
export LESS_TERMCAP_mb=$'\E[31m'
export LESS_TERMCAP_md=$'\E[31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[1;40;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[32m'

export XDG_CONFIG_HOME="$HOME/.config"

if hash keychain > /dev/null 2>&1; then
    eval "$(keychain --eval --quiet id_rsa id_ed25519 build_dsa build_rsa > /dev/null 2>&1)"
fi

# if [ -f "${HOME}/.gpg-agent-info" ]; then
#     . "${HOME}/.gpg-agent-info"
#     export GPG_AGENT_INFO
#     export SSH_AUTH_SOCK
# fi

# SSH_AUTH_SOCK=`ss -xl | grep -o '/run/user/1000/keyring-.*/ssh'`
# [ -z "$SSH_AUTH_SOCK" ] || export SSH_AUTH_SOCK

. "$HOME/dotfiles/scalerc"

[ -n "$XTERM_VERSION" ] && transset-df .9 -a >/dev/null
#use solarized ls colors
#eval $(dircolors ~/.dir_colors)

FZF_DIR="$HOME/.fzf/bin/"
if [ -d $FZF_DIR ] || hash fzf; then
    export PATH=$PATH:$FZF_DIR
    export FZF_DEFAULT_OPTS="--reverse --height 40%"
    if hash rg 2> /dev/null; then
        export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden -g "!{.git,node_modules}/*" 2> /dev/null'
    fi
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_CTRL_T_OPTS="--select-1 --exit-0"
    if hash bfs 2> /dev/null; then
        export FZF_ALT_C_COMMAND="bfs . -type d -nohidden"
    fi
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
fi
