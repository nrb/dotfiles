UNAME=$(uname)
source $HOME/.commonfuncs

# Common hashes
#hash -d L=/var/log
#hash -d R=/usr/local/etc/rc.d

# OS X specific settings
if [ $UNAME = "Darwin" ]; then
    
    # set up dir hashes
    #hash -d P=$HOME/sixfeetup/projects
    #hash -d S=$HOME/Sites

fi

# set up common aliases between shells
source $HOME/.commonrc

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
if checkPath colordiff; then
    alias -g CD='| colordiff'
else
    alias -g CD='| vim -R -'
fi
# bootstrap with distribute
#alias -g bootstrap='bootstrap.py --distribute'

# turn off the stupid bell
#setopt NO_BEEP

# automatically print timing statistics if the command took longer
# than a minute
export REPORTTIME=60

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

# Look for a command that started like the one starting on the command line.
# taken from: http://www.xsteve.at/prg/zsh/.zshrc (not sure of original source)
function history-search-end {
    integer ocursor=$CURSOR

    if [[ $LASTWIDGET = history-beginning-search-*-end ]]; then
      # Last widget called set $hbs_pos.
      CURSOR=$hbs_pos
    else
      hbs_pos=$CURSOR
    fi

    if zle .${WIDGET%-end}; then
      # success, go to end of line
      zle .end-of-line
    else
      # failure, restore position
      CURSOR=$ocursor
      return 1
    fi
}

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# set up the history-complete-older and newer
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# vi command line editor
########################
# TODO: Un-comment the following line to have vi style keybindings
#bindkey -v
# use home and end to go to end and beginning of the line
bindkey -M viins '^A' vi-beginning-of-line
bindkey -M viins '^E' vi-end-of-line
bindkey -M viins '^[[H' vi-beginning-of-line
bindkey -M viins '^[[F' vi-end-of-line
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
# set up for insert mode too
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^F' history-incremental-pattern-search-forward
# complete previous occurences of the command up till now on the command line
bindkey -M viins "^[OA" history-beginning-search-backward-end
bindkey -M viins "^[[A" history-beginning-search-backward-end
bindkey -M viins "^N" up-line-or-search
bindkey -M viins "^[OB" history-beginning-search-forward-end
bindkey -M viins "^[[B" history-beginning-search-forward-end
bindkey -M viins "^P" down-line-or-search

# edit current command in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# History settings
##################
HISTSIZE=3000
SAVEHIST=3000
HISTFILE=~/.zsh_history
export HISTFILE HISTSIZE SAVEHIST

# Completions
#############
#autoload -U compinit
#compinit -C
# case-insensitive (all),partial-word and then substring completion
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# uncomment this to show when you aren't the current user
#ME="clayton"

# use some crazy ass shell prompt
# thanks to for the basis: http://aperiodic.net/phil/prompt/
#source $HOME/.zshprompt

# use a simpler 3 line prompt
source $HOME/.zshprompt_simple

# load up per environment extras
source ~/.zshextras
