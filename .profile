if [ -d .config/bash ]; then
  for i in .config/bash/* ; do
    . $i
  done
  unset i
  my_bash_prompt
fi
