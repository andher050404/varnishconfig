#!/bin/bash
echo $(date) "should be done" >> /root/varnish/varnish.log.log
echo $VARNISH_LOG_WDIR "is the log wdir" >> /root/varnish/varnish.log.log