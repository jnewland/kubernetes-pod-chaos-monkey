#!/bin/bash
# Randomly delete pods in a Kubernetes namespace.
set -ex

: ${DELAY:=30}
: ${NAMESPACE:=default}
: ${FORCE:=false}

if [ "${FORCE}" == "true" ]; then
  CMD_FORCE="--force --grace-period=0"
else
  CMD_FORCE=""
fi

while true; do
  kubectl \
    --namespace "${NAMESPACE}" \
    -o 'jsonpath={.items[*].metadata.name}' \
    get pods | \
      tr " " "\n" | \
      shuf | \
      head -n 1 |
      xargs -t --no-run-if-empty \
        kubectl --namespace "${NAMESPACE}" delete pod ${CMD_FORCE}
  sleep "${DELAY}"
done
