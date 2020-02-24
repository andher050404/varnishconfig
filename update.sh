#!/bin/bash

cd

kill -9 $(cat ${VARNISH_CLIENT_LOG_PID}) && rm -f ${VARNISH_CLIENT_LOG_PID}
kill -9 $(cat ${VARNISH_BACKEND_LOG_PID}) && rm -f ${VARNISH_BACKEND_LOG_PID}

kill -9 $(cat varnish/varnish.pid) && rm -f varnish/varnish.pid

cd /root/varnishconfig

git pull

cd

cp varnishconfig/default.vcl ${VARNISH_DEFAULT}
cp varnishconfig/secret ${VARNISH_SECRET}
cp varnishconfig/stopVarnish.sh ${VARNISH_STOP}
cp varnishconfig/rotateLogs.sh ${VARNISH_LOG_ROTATE}
cp varnishconfig/varnishFormatString ${VARNISH_LOGGING_FORMAT}
cp varnishconfig/update.sh varnish/update.sh
cp varnishconfig/varnish /etc/default/varnish
cp varnishconfig/varnishinit.d /etc/init.d/varnish
crontab -r
crontab varnishconfig/crontab

service varnish start -P varnish/varnish.pid

varnishncsa -a -c -w ${VARNISH_CLIENT_LOG} -D -P ${VARNISH_CLIENT_LOG_PID} -f ${VARNISH_LOGGING_FORMAT}

varnishncsa -a -b -w ${VARNISH_BACKEND_LOG} -D -P ${VARNISH_BACKEND_LOG_PID} -f ${VARNISH_LOGGING_FORMAT}