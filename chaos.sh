#!/bin/bash
# Randomly delete pods in a Kubernetes namespace.
set -ex

: ${DELAY:=30}
: ${NAMESPACE:=default}

if [ "${SELECTOR_MODE}" == "equality-based" ] || [ "${SELECTOR_MODE}" == "set-based" ]; then 
  while true; do
    kubectl \
      --namespace "${NAMESPACE}" \
      -o 'jsonpath={.items[*].metadata.name}' \
      get pods --selector \
      "${SELECTOR}" | \
        tr " " "\n" | \
        shuf | \
        head -n 1 |
        xargs -t --no-run-if-empty \
          kubectl --namespace "${NAMESPACE}" delete pod
    sleep "${DELAY}"
  done
else 
  while true; do
    kubectl \
      --namespace "${NAMESPACE}" \
      -o 'jsonpath={.items[*].metadata.name}' \
      get pods | \
        tr " " "\n" | \
        shuf | \
        head -n 1 |
        xargs -t --no-run-if-empty \
          kubectl --namespace "${NAMESPACE}" delete pod
    sleep "${DELAY}"
  done
fi
