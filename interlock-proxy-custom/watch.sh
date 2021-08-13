#!/bin/sh

event="$1"
directory="$2"
file="$3"

echo $(date +%s) - $event - $directory - $file

case "$event" in
#u|o|x) # Inotify problems - kill nginx and let swarm respawn us
#   kill -9 1
#   ;;
w) # Any other change
   # may not want to have this copy
   # we need to exclude read and access because the copy triggers those
   # however with just W we weren't getting anything
   # an update being written into the volume seems to look
   # like c or w, or possibly dnrc.   Our copying the file looks like ra0
   echo Updating /etc/nginx/nginx.conf
   cp /out/nginx/nginx.conf /etc/nginx/nginx.conf
   echo "watch.sh: adding fail_timeout and max_fails"
   sed -i -e '/server / s/;/ fail_timeout=0s max_fails=1000;/g' /etc/nginx/nginx.conf
   nginx -t
   nginx -s reload
   ;;
esac
