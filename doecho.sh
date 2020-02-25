#!/bin/bash
. <(xargs -0 bash -c 'printf "export %q\n" "$@"' -- < /proc/1/environ)
echo $(date) "should be done" >> /root/varnish/varnish.log.log
echo $VARNISH_LOG_WDIR "is the log wdir" >> /root/varnish/varnish.log.log