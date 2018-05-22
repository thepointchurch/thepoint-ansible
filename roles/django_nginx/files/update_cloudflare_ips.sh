#!/bin/sh

(/usr/bin/curl -s https://www.cloudflare.com/ips-v4; /bin/echo; /usr/bin/curl -s https://www.cloudflare.com/ips-v6; /bin/echo) \
    | sed -e "/^$/d" -e "s/^/set_real_ip_from /" -e "s/$/;/"
echo 'real_ip_header X-Forwarded-For;'
echo 'real_ip_recursive on;'
