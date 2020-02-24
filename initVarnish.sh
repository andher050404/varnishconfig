#!/bin/bash
cd

varnishconfig/update.sh

#service varnish start -P /varnish/varnish.pid

#varnishncsa -a -c -w ${VARNISH_CLIENT_LOG} -D -P ${VARNISH_CLIENT_LOG_PID} -f ${VARNISH_LOGGING_FORMAT}

#varnishncsa -a -b -w ${VARNISH_BACKEND_LOG} -D -P ${VARNISH_BACKEND_LOG_PID} -f ${VARNISH_LOGGING_FORMAT}

#/usr/sbin/cron -f -l 8
/usr/bin/crontab varnishconfig/crontab