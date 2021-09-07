UNAME=$(uname)

# Common hashes
#hash -d L=/var/log
#hash -d R=/usr/local/etc/rc.d

# global aliases
################
# disable the plonesite part in a buildout run, example: $ bin/buildout -N psef
#alias -g psef="plonesite:enabled=false"
# get the site packages for your python, example: $ cd $(python2.5 site-packages)
#alias -g site_packages='-c "from distutils.sysconfig import get_python_lib; print get_python_lib()"'
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
   alias ls="ls -G"
elif [ $UNAME = "Linux" ]; then
   alias ls="ls --color=auto -F"
fi

# show me everything
alias ll='ls -al'
# sort by size
alias lss='ll -Sr'
# sort by date modified
alias lsdate='lsa -tr'
# ll but human readable size
alias lsa='ll -H'
# don't list directories
alias lsd='lsa -d'
# list all dot files
alias lsdot='lsd .*'

# output more lines so that you can grep them
alias psa='ps axwww'
# grep through processes
alias psg='psa | grep -i'


alias gti='git'
alias ga='git add'
alias pythong='echo lol; python'
alias k=kubectl
alias mkgotags='gotags -R -f tags .'
alias til='vim $HOME/til/$(date +%Y-%m-%d).md'
alias ark='/home/nrb/go/src/github.com/heptio/velero/_output/bin/linux/amd64/velero'
alias v='$HOME/go/src/github.com/vmware-tanzu/velero/_output/bin/$(uname | tr "[:upper:]" "[:lower:]")/amd64/velero'

if [[ $UNAME == "Linux" ]]; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
    alias open='xdg-open'
fi


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



# Completions
#############
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

# set up the history-complete-older and newer
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# load up per environment extras
source ~/.zshextras


if $(which direnv > /dev/null); then
    eval "$(direnv hook zsh)"
fi

if [ -d "$HOME/google-cloud-sdk" ]; then
    source "$HOME/google-cloud-sdk/completion.zsh.inc"
    source "$HOME/google-cloud-sdk/path.zsh.inc"
fi

# From Homebrew on macos
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh

eval "$(starship init zsh)"

