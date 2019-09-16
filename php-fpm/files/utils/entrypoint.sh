#!/usr/bin/env sh
# $0 is a script name,
# $1, $2, $3 etc are passed arguments
# $1 is our command
CMD=$1

case "$CMD" in
  "websocket" )
    # Ensure crontab doesnt run in this type of container/role
    sed -i 's/?!#\(.*artisan schedule.*\)/# \1/' /etc/crontabs/www-data
    exec php artisan websockets:serve
    ;;

  "scheduler" )
    sed -i 's/# \(.*artisan schedule.*\)/\1/' /etc/crontabs/www-data
    exec crond -f -l 0 -d 8 -c /etc/crontabs
    ;;

  "horizon" )
    # Ensure crontab doesnt run in this type of container/role
    sed -i 's/?!#\(.*artisan schedule.*\)/# \1/' /etc/crontabs/www-data
    # we can modify files here, using ENV variables passed in
    # "docker create" command. It can't be done during build process.
    exec /utils/horizon.sh
    ;;

  "api" )
    # Ensure crontab doesnt run in this type of container/role
    sed -i 's/?!#\(.*artisan schedule.*\)/# \1/' /etc/crontabs/www-data
    # we can modify files here, using ENV variables passed in
    # "docker create" command. It can't be done during build process.
    exec /utils/init.sh
    ;;

   * )
    # Run custom command. Thanks to this line we can still use
    # "docker run our_image /bin/bash" and it will work
    exec $CMD ${@:2}
    ;;
esac