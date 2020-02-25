#!/bin/bash
env - `cat /root/varnish/env.sh` /bin/sh
echo $(date) "should be done" >> /root/varnish/varnish.log.log
echo $VARNISH_LOG_WDIR "is the log wdir" >> /root/varnish/varnish.log.log