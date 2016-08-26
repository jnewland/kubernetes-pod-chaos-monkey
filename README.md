# Kubernetes Pod Chaos Monkey

This repository contains a `Dockerfile` and associated Kubernetes configuration for a Deployment that will randomly delete pods in a given namespace. This is implemented in Bash mostly because I'm writing this for a lightning talk.

An image built from the `Dockerfile` in this repository is available on Docker Hub as [`jnewland/kubernetes-pod-chaos-monkey`](https://hub.docker.com/r/jnewland/kubernetes-pod-chaos-monkey/).

Example Kubernetes config is included at [`config/kubernetes/production/deployment.yaml`](./config/kubernetes/production/deployment.yaml)

## License

[MIT](./LICENSE.md)
