#!/bin/zsh
if [ -d $HOME/.config/zsh ]; then
  for i in $HOME/.config/zsh/* ; do
    . $i
  done
  unset i
  echo -e -n "\x1b[\x35 q"
  my_zsh_prompt
fi
