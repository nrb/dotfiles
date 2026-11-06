# .zshrc


# Load all files from .shell/zshrc.d directory
if [ -d $HOME/.dotfiles/.shellrc/zshrc.d ]; then
  for file in $HOME/.dotfiles/.shellrc/zshrc.d/*.zsh; do
    source $file
  done
fi

# opencode
export PATH=/Users/nbrubake/.opencode/bin:$PATH
