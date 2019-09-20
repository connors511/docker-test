#!/usr/bin/env bash
# $0 is a script name,
# $1, $2, $3 etc are passed arguments
# $1 is our command
CMD=$1

echo "export PS1='??  \[\033[1;36m\]\h \[\033[1;34m\]\W\[\033[0;35m\] \[\033[1;36m\]# \[\033[0m\]'" >> $HOME/.bashrc
echo "alias ll='ls -lh'" >> $HOME/.bashrc
echo "alias art='php artisan'" >> $HOME/.bashrc
echo "alias phpunit='vendor/bin/phpunit'" >> $HOME/.bashrc
echo "alias p='phpunit'" >> $HOME/.bashrc
echo "alias pf='phpunit --filter'" >> $HOME/.bashrc
echo "alias pst='phpunit --stop-on-failure'" >> $HOME/.bashrc
echo "alias paratest='vendor/bin/paratest --colors'" >> $HOME/.bashrc

if [ -f "/utils/${CMD}.sh" ]; then
  if [ "$CMD" = "scheduler" ]; then
    SKIP_MIGRATIONS=1
  fi

  /utils/init.sh
  echo "Starting service: ${CMD}"
  exec /utils/${CMD}.sh
else
  # Run custom command. Thanks to this line we can still use
  # "docker run our_image /bin/bash" and it will work
  exec $CMD ${@:2}
fi