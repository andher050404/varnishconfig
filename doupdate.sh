#!/bin/bash
. <(xargs -0 bash -c 'printf "export %q\n" "$@"' -- < /proc/1/environ)
${VARNISH_UPDATE}