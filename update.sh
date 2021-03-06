#!/bin/bash

kill -9 $(cat ${VARNISH_CLIENT_LOG_PID}) && rm -f ${VARNISH_CLIENT_LOG_PID}
kill -9 $(cat ${VARNISH_BACKEND_LOG_PID}) && rm -f ${VARNISH_BACKEND_LOG_PID}

kill -9 $(cat ${VARNISH_PID})

cd ${VARNISH_CONFIG}

git pull

chmod -R 777 ${VARNISH_HOME}
chmod -R 777 ${VARNISH_CONFIG}

cp ${VARNISH_CONFIG}/default.vcl ${VARNISH_DEFAULT}
cp ${VARNISH_CONFIG}/secret ${VARNISH_SECRET}

crontab -r
crontab ${VARNISH_CONFIG}/crontab

varnishd -a 0.0.0.0:${VARNISH_LISTEN_PORT} -f ${VARNISH_DEFAULT} -S ${VARNISH_SECRET} -p ${VARNISH_POOLS_SIZE} -p ${VARNISH_MIN_THREADS} -p ${VARNISH_MAX_THREADS} -t ${VARNISH_CACHE_TTL} -P ${VARNISH_PID}

cp ${VARNISH_CLIENT_LOG} ${VARNISH_CLIENT_LOG_ROTATE}$(date '+_%Y_%m_%d') && > ${VARNISH_CLIENT_LOG}
cp ${VARNISH_BACKEND_LOG} ${VARNISH_BACKEND_LOG_ROTATE}$(date '+_%Y_%m_%d') && > ${VARNISH_BACKEND_LOG}
cp ${TINY_LOG} ${TINY_LOG_ROTATE}$(date '+_%Y_%m_%d') && > ${TINY_LOG}

varnishncsa -a -c -w ${VARNISH_CLIENT_LOG} -D -P ${VARNISH_CLIENT_LOG_PID} -f ${VARNISH_LOGGING_FORMAT}

varnishncsa -a -b -w ${VARNISH_BACKEND_LOG} -D -P ${VARNISH_BACKEND_LOG_PID} -f ${VARNISH_LOGGING_FORMAT}#Test
