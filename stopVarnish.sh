kill -9 $(cat ${VARNISH_PID}) && rm -f ${VARNISH_PID}
kill -9 $(cat ${VARNISH_CLIENT_LOG_PID}) && rm -f ${VARNISH_CLIENT_LOG_PID}
kill -9 $(cat ${VARNISH_BACKEND_LOG_PID}) && rm -f ${VARNISH_BACKEND_LOG_PID}