#!/bin/sh

# may be a race where conf is written before we start inotifyd
# so we need to start by unconditionally copying the config file
cp /out/nginx/nginx.conf /etc/nginx/nginx.conf
echo "entrypiont.sh: adding fail_timeout and max_fails"
sed -i -e '/server / s/;/ fail_timeout=0s max_fails=1000;/g' /etc/nginx/nginx.conf
nginx -t

# Kill all processes in this process group if any one of them exits
trap 'kill 0' CHLD

# Shut down nginx gracefully if we receive SIGTERM or SIGQUIT
trap 'kill -QUIT $NGINX && wait' TERM QUIT

# Start inotifyd and nginx in the background - this shell will wait
# for both of them to exit
inotifyd /watch.sh /out/nginx &
nginx -g "daemon off;" &
NGINX=$!

# Block until all child processes exit.   If any child exits, the signal
# will be trapped and all will be killed.
wait
