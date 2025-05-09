
# rationalize-path()
# Later we'll need to trim down the paths that follow because the ones
# given here are for all my accounts, some of which have unusual
# paths in them.  rationalize-path will remove
# nonexistent directories from an array.
rationalize-path () {
  # Note that this works only on arrays, not colon-delimited strings.
  # Not that this is a problem now that there is typeset -T.
  local element
  local build
  build=()
  # Evil quoting to survive an eval and to make sure that
  # this works even with variables containing IFS characters, if I'm
  # crazy enough to setopt shwordsplit.
  eval '
  foreach element in "$'"$1"'[@]"
  do
    if [[ -d "$element" ]]
    then
      build=("$build[@]" "$element")
    fi
  done
  '"$1"'=( "$build[@]" )
  '
}

# Take care of setting an FPATH for all occasions.
# Something seems very wrong about all of this

# look for /usr/share version
if [ -d /usr/share/zsh/$ZSH_VERSION ]; then
    fpath+=(/usr/share/zsh/$ZSH_VERSION*/**/*(/))
fi

# look for /usr/local/share
if [ -d /usr/local/share/zsh/$ZSH_VERSION ]; then
    fpath+=(/usr/local/share/zsh/$ZSH_VERSION*/**/*(/))
fi

# look for /opt/local/share
if [ -d /opt/local/share/zsh/$ZSH_VERSION ]; then
    fpath+=(/opt/local/share/zsh/$ZSH_VERSION*/**/*(/))
fi

if [ -d $HOME/.cargo/bin ]; then
    fpath+=($HOME/.cargo/bin) 
fi

# Set the lowest common options
fpath+=(
    /usr/local/share/zsh/functions
    /usr/local/share/zsh/site-functions
    /usr/share/zsh/site-functions
    /usr/share/zsh/functions
    "$fpath[@]"
)

export FPATH
# Only unique entries please.
typeset -U fpath
# Remove entries that don't exist on this system.  Just for sanity's
# sake more than anything.
rationalize-path fpath

# Set our PATH up
# Make sure homebrew is in there for the EDITOR check
PATH=$HOME/bin:${ASDF_DATA_DIR:-$HOME/.asdf}/shims:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/Users/nbrubake/Library/Python/3.11/bin:$PATH

# Enable a few things for less (This will also apply to man)
#   * turn off case sensitive search (-I)
#   * display a long prompt with more info (-M)
#   * show colors instead of escape characters (-R)
export LESS="-IMR"

if $(which nvim > /dev/null); then
    export EDITOR=nvim
else
    export EDITOR=vi
fi

# use a fancy terminal
export TERM=xterm-256color

# History settings
##################
HISTSIZE=3000
SAVEHIST=3000
HISTFILE=~/.zsh_history
export HISTFILE HISTSIZE SAVEHIST

# Avoid tarring up macOS files
export COPYFILE_DISABLE="True"
export COPY_EXTENDED_ATTRIBUTES_DISABLE="True"

# Shortcuts
export P=~/projects

if [ -f /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ -f $HOME/.cargo/env ]; then
	source $HOME/.cargo/env
fi

# On macOS, override the ssh-agent socket and use 1Password
if [ -f $HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ]; then
    export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
fi

# Openshift makefiles have issues with containers on arm64. Turn it off for now
export NO_DOCKER=1

alias docker=podman
