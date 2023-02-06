#!/bin/bash
set -euo pipefail

VERBOSE=false
PRSERVER_DATA=/home/docker/prserv
PRSERVER_LOG="${PRSERVER_DATA}/prserv.log"
PRSERVER_HOST=${PRSERVER_HOST:-0.0.0.0}
PRSERVER_PORT=${PRSERVER_PORT:-8585}
prserver_pidfile="/run/prserver_${PRSERVER_HOST}_${PRSERVER_PORT}.pid"

touch "${PRSERVER_LOG}"

stop_server() {
	start-stop-daemon --stop \
		--oknodo \
		--pidfile "${prserver_pidfile}" \
		--remove-pidfile \
	""
	trap - SIGINT SIGTERM
}

start_server() {
	echo "INFO: Starting PR server on ${PRSERVER_HOST}:${PRSERVER_PORT}"
	local loglevel_args="--loglevel=INFO"
	[ "${VERBOSE}" == true ] && loglevel_args="--loglevel=DEBUG"

	start-stop-daemon --start \
		--startas /srv/bitbake/bin/bitbake-prserv \
		--oknodo \
		--pidfile "${prserver_pidfile}" \
		--user docker \
		python /srv/bitbake/bin/bitbake-prserv \
		-- \
			--start \
			--file="${PRSERVER_DATA}/prserv.sqlite3" \
			--log="${PRSERVER_LOG}" \
			${loglevel_args} \
			--host=${PRSERVER_HOST} \
			--port=${PRSERVER_PORT} \
	""
	trap stop_server SIGINT SIGTERM
}

stop_server
start_server

# Print diagnostic info
ps aux

# Monitor the prserver log file and use it as the loop which keeps this init
# process alive until the pr-server is done.
read prserver_pid <"${prserver_pidfile}"
tail --pid=${prserver_pid} -f ${PRSERVER_LOG} -n 0 &
wait $!

stop_server















# #! /bin/bash
# set -x

# cat start.sh 

# source ./oe-init-build-env ../build
# bitbake-prserv --start --file /home/docker/prserv/sqlite3.db --log /tmp/prserv.log --port 34328
# tail -f /tmp/prserv.log

# exit_script(){
#     cd /home/docker/poky
#     source ./oe-init-build-env /home/docker/prserv
#     bitbake-prserv --stop || true
#     sleep 1
#     trap - SIGINT SIGTERM
#     kill -- -$$
# }

# trap exit_script SIGINT SIGTERM