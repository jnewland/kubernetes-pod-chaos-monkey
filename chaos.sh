#!/bin/bash
# Randomly delete pods in a Kubernetes namespace.
set -ex

: ${DELAY:=30}

rand_resource() {
  shuf | head -n 1
}

kubectl_cmd() {
  kubectl -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' "$@"
}

while true; do
  NAMESPACE=$(kubectl_cmd get namespaces | grep -v 'kube-system' | rand_resource)

  kubectl_cmd --namespace "$NAMESPACE" get pods | \
    rand_resource | \
    xargs -t --no-run-if-empty \
      kubectl --namespace "${NAMESPACE}" delete pod

  sleep "${DELAY}"
done
