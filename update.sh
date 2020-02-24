#!/bin/bash

cd

kill -9 $(cat ${VARNISH_CLIENT_LOG_PID}) && rm -f ${VARNISH_CLIENT_LOG_PID}
kill -9 $(cat ${VARNISH_BACKEND_LOG_PID}) && rm -f ${VARNISH_BACKEND_LOG_PID}

kill -9 $(cat varnish/varnish.pid)

cd /root/varnishconfig

git pull

cd

cp varnishconfig/default.vcl ${VARNISH_DEFAULT}
cp varnishconfig/secret ${VARNISH_SECRET}
cp varnishconfig/rotateLogs.sh ${VARNISH_LOG_ROTATE}
cp varnishconfig/varnishFormatString ${VARNISH_LOGGING_FORMAT}
cp varnishconfig/update.sh varnish/update.sh

crontab -r
crontab varnishconfig/crontab

cd /root/varnish
varnishd -a 0.0.0.0:${VARNISH_LISTEN_PORT} -f ${VARNISH_DEFAULT} -S ${VARNISH_SECRET} -p ${VARNISH_POOLS_SIZE} -p ${VARNISH_MIN_THREADS} -p ${VARNISH_MAX_THREADS} -t ${VARNISH_CACHE_TTL} -P varnish.pid
cd
echo $(date -u) "Service startet" >> varnish/varnish.log

varnishncsa -a -c -w ${VARNISH_CLIENT_LOG} -D -P ${VARNISH_CLIENT_LOG_PID} -f ${VARNISH_LOGGING_FORMAT}

varnishncsa -a -b -w ${VARNISH_BACKEND_LOG} -D -P ${VARNISH_BACKEND_LOG_PID} -f ${VARNISH_LOGGING_FORMAT}