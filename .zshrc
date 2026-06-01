#!/bin/zsh
if [ -d "$HOME/.config/zsh" ]; then
  for i in "$HOME"/.config/zsh/* ; do
    [ -r "$i" ] && . "$i"
  done
  unset i
  echo -e -n "\x1b[\x35 q"
  my_zsh_prompt
fi

# Secrets are loaded from ~/.config/zsh/secrets (untracked) by the loop above.
# NEVER put tokens/keys in this file — .zshrc is tracked by git.

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if [ -d "$HOME/anaconda3" ]; then
  __conda_setup="$("$HOME/anaconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  elif [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
    . "$HOME/anaconda3/etc/profile.d/conda.sh"
  else
    export PATH="$HOME/anaconda3/bin:$PATH"
  fi
  unset __conda_setup
fi
# <<< conda initialize <<<

# Added by Antigravity
[ -d "$HOME/.antigravity/antigravity/bin" ] && export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
