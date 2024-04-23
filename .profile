if [ -d .config/bash ]; then
  for i in .config/bash/* ; do
    . $i
  done
  unset i
  echo -e -n "\x1b[\x35 q"
  my_bash_prompt
fi
