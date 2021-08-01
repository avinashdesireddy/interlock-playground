#!/bin/bash

LOG_DIR=/tmp/nginx_status_logs
mkdir -p $LOG_DIR

# source bundle
BUNDLE_DIR=
cd $BUNDLE_DIR
source env.sh
cd -
# Get the IPs of container running ucp-interlock-proxy
endpoints=$(docker container ls -a --filter "status=running" --filter="name=ucp-interlock-proxy" --format '{{ .Ports }}' | cut -f1 -d":")

for endpoint in $endpoints;
do
  nginx_status_endpoint=nginx_status_$(echo $endpoint | cut -f1 -d":" )
  echo $(date) $(curl http://$endpoint/nginx_status | tr '\n' ' ') >> ${LOG_DIR}/${nginx_status_endpoint}.log
  #echo $endpoint $nginx_status_endpoint
done
