# general
export GPG_TTY="$(tty)"
export TERM="xterm-256color"
export VISUAL="$(which lvim)"
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|-|cd ..|..|clear|pass|gpg)"
export PATH="$HOME/.local/bin:$PATH" # local binaries

# pagers
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export GIT_PAGER="delta --paging=never"

# starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG="$HOME/.config/starship.toml"

# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# aliases
[ -f ~/.zsh_aliases ] && \. $HOME/.zsh_aliases

# functions
[ -f ~/.zsh_functions ] && \. $HOME/.zsh_functions

# homebrew
if type brew &>/dev/null
then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

    autoload -Uz compinit
    compinit
fi

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # this loads key bindings and fuzzy completion
export FZF_DEFAULT_COMMAND='rg --hidden -l ""'
export FZF_DEFAULT_OPTS='--color=fg:#ebfafa,bg:#282a36,hl:#37f499 --color=fg+:#ebfafa,bg+:#212337,hl+:#37f499 --color=info:#f7c67f,prompt:#04d1f9,pointer:#7081d0 --color=marker:#7081d0,spinner:#f7c67f,header:#323449'

bindkey -r '^T'
bindkey '^F' fzf-file-widget

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh" # this loads nvm
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" # this loads nvm bash_completion
export NVM_COLORS='cmgRY'

autoload -U add-zsh-hook
load-nvmrc() {
local node_version="$(nvm version)"
local nvmrc_path="$(nvm_find_nvmrc)"

if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use
    fi
elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# docker
fpath=(/Users/minami/.docker/completions $fpath)
autoload -Uz compinit
compinit

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# asdf
export ASDF_DIR='/usr/local/opt/asdf/libexec'
. /usr/local/opt/asdf/libexec/asdf.sh

# gcloud
if [ -f '/Users/minami/Downloads/google-cloud-sdk/path.zsh.inc' ]; then 
    . '/Users/minami/Downloads/google-cloud-sdk/path.zsh.inc';
fi
if [ -f '/Users/minami/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then 
    . '/Users/minami/Downloads/google-cloud-sdk/completion.zsh.inc';
fi

# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# ruby
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

# bat
export BAT_THEME="Eldritch"

# thefuck
eval $(thefuck --alias)

# webstorm
export PATH="/Applications/WebStorm.app/Contents/MacOS:$PATH"

# zplug
export ZPLUG_HOME="$HOME/.zplug"
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "changyuheng/zsh-interactive-cd"
zplug "changyuheng/fz", defer:1
zplug "rupa/z", use:z.sh
zplug "jscutlery/nx-completion"

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load # this load zlug plugins and add commands
