FROM mirantis/ucp-interlock-proxy:3.3.5

COPY entrypoint.sh watch.sh /
RUN chmod 755 /entrypoint.sh /watch.sh
CMD ["/entrypoint.sh"]
