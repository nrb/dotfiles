UNAME=$(uname)

# Common hashes
#hash -d L=/var/log
#hash -d R=/usr/local/etc/rc.d

# global aliases
################
# some pipes
alias -g G='| grep'
alias -g L='| less'
alias -g M='| more'
alias -g T='| tail'
alias -g TT='| tail -n20'

# make copy and move ask before replacing files
alias cp='cp -i'
alias mv='mv -i'

# ls aliases
############
# conditionally set up coloring on different OS types
if [ $UNAME = "FreeBSD" ] || [ $UNAME = "Darwin" ]; then
   alias ls="ls -Gh"
elif [ $UNAME = "Linux" ]; then
   alias ls="ls --color=auto -FH"
fi

# show me everything
alias ll='ls -al'
# sort by size
alias lss='ll -Sr'
# sort by date modified
alias lsdate='lsa -tr'
# don't list directories
alias lsd='lsa -d'
# list all dot files
alias lsdot='lsd .*'

# output more lines so that you can grep them
alias psa='ps axwww'
# grep through processes
alias psg='psa | grep -i'

## command shortcuts
alias gti='git'
alias ga='git add'
alias gw='git worktree'
alias pythong='echo lol; python'
alias k=kubectl
alias d=docker
alias p=podman
alias mkgotags='gotags -R -f tags .'
alias v="$EDITOR"
alias til='vim $HOME/til/$(date +%Y-%m-%d).md'

## config file shortcuts
alias ec="$EDITOR $HOME/.dotfiles/.zshrc"
alias sc="source $HOME/.dotfiles/.zshrc"
alias enc="$EDITOR $HOME/.dotfiles/.config/nvim/init.vim"
alias evc="$EDITOR $HOME/.dotfiles/.vimrc"

## navigation shortcuts
alias dots="$HOME/.dotfiles"

if [[ $UNAME == "Linux" ]]; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
    alias open='xdg-open'
fi

# Configure certain file types to be opened with a program when created
alias -s {go,ts,html,css,js,md,vim}="$EDITOR"


# Changing Directories
setopt AUTO_CD CDABLE_VARS
# automatically save recent directories on the stack
setopt AUTO_PUSHD
setopt PUSHDMINUS
setopt PUSHD_IGNORE_DUPS

# History
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# vi command line editor
########################
bindkey "^l" clear-screen
bindkey -v
# use ctrl+a and ctrl+e like emacs mode
bindkey -M viins '^A' vi-beginning-of-line
bindkey -M viins '^E' vi-end-of-line
# use delete as forward delete
bindkey -M viins '\e[3~' vi-delete-char
# line buffer
bindkey -M viins '^B' push-line-or-edit
# change the shortcut for expand alias
bindkey -M viins '^X' _expand_alias
# Search backwards with a pattern
bindkey -M vicmd '^R' history-incremental-pattern-search-backward
bindkey -M vicmd '^F' history-incremental-pattern-search-forward
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
# set up for insert mode too
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^F' history-incremental-pattern-search-forward
# complete previous occurences of the command up till now on the command line
bindkey -M viins "^[OA" history-beginning-search-backward-end
bindkey -M viins "^[[A" history-substring-search-up
bindkey -M viins "^N" up-line-or-search
bindkey -M viins "^[OB" history-beginning-search-forward-end
bindkey -M viins "^[[B" history-substring-search-down
bindkey -M viins "^P" down-line-or-search

# edit current command in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Use vi key bindings in menu selection
# Must run before compinit
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# tab completion directories, without full path.
cdpath=($HOME/projects $HOME)

# Completions
#############

# Integrate with Homebrew's completions, if available
# Must come before the standard compinit
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

autoload -U compinit
compinit -C
# Define completers
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Group completions by type
zstyle ':completion:*' group-name ''

# Describe the types with a format string
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'

# case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Allow you to select in a menu
zstyle ':completion:*' menu selectstyle

# path completions. Use local directories first, then cdpath ones
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'

# set up the history-complete-older and newer
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes


if $(which direnv > /dev/null); then
    eval "$(direnv hook zsh)"
fi

if [ -d "$HOME/google-cloud-sdk" ]; then
    source "$HOME/google-cloud-sdk/completion.zsh.inc"
    source "$HOME/google-cloud-sdk/path.zsh.inc"
fi

# Borrowed from Homebrew on macos.
# source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source $HOME/.dotfiles/zshscripts/zsh-history-substring-search.zsh

eval "$(starship init zsh)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

source $HOME/.config/op/plugins.sh

# pipx installed scripts
export PATH="$PATH:/Users/nbrubake/.local/bin"

source <(fzf --zsh)
