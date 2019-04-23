#!/bin/bash
# Portforward hack for CircleCI remote docker
set -o errexit
set -o nounset
set -o pipefail
set -o errtrace

wait=
if [[ ${1:-} = -wait ]]; then
  wait=1
  shift
fi
if [ "${DIND_PORT_FORWARDER_WAIT:-}" = "1" ]; then
  wait=1
fi

if [[ ${1:-} = start ]]; then
  docker run -d -it \
         --name portforward --net=host \
         --entrypoint /bin/sh \
         bobrik/socat -c "while true; do sleep 1000; done"
elif [[ ${1} ]]; then
  port="${1}"
  mode=""
  localhost="localhost"
  if [[ "${IP_MODE:-ipv4}" = "ipv6" ]]; then
    mode="6"
    localhost="[::1]"
  fi
  socat "TCP-LISTEN:${port},reuseaddr,fork" \
        EXEC:"'docker exec -i portforward socat STDIO TCP${mode}:${localhost}:${port}'" &
  if [[ ${wait} ]]; then
    for ((n = 0; n < 20; n++)); do
      if socat - "TCP${mode}:localhost:${port}" </dev/null; then
        break
      fi
      sleep 0.5
    done
  fi
else
  echo "Must specify either start or the port number" >&2
  exit 1
fi
