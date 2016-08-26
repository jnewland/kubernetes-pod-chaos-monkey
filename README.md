# Kubernetes Pod Chaos Monkey

This repository contains a `Dockerfile` and associated Kubernetes configuration for a Deployment that will randomly delete pods in a given namespace. This is implemented in Bash mostly because I'm writing this for a lightning talk.

An image built from the `Dockerfile` in this repository is available on Docker Hub as [`jnewland/kubernetes-pod-chaos-monkey`](https://hub.docker.com/r/jnewland/kubernetes-pod-chaos-monkey/).

Example Kubernetes config is included at [`config/kubernetes/production/deployment.yaml`](./config/kubernetes/production/deployment.yaml)

```bash
$ kubectl logs kubernetes-pod-chaos-monkey-3294408070-6w6oh
+ : 30
+ : default
+ true
+ xargs -t --no-run-if-empty kubectl --namespace default delete pod
+ head -n 1
+ shuf
+ tr ' ' '\n'
+ kubectl --namespace default -o 'jsonpath={.items[*].metadata.name}' get pods
kubectl --namespace default delete pod dd-agent-3hw6w
pod "dd-agent-3hw6w" deleted
+ sleep 30
```

## License

[MIT](./LICENSE.md)
