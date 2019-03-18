# Kubernetes Pod Chaos Monkey

This repository contains a `Dockerfile` and associated Kubernetes configuration for a Deployment that will randomly delete pods in a given namespace. This is implemented in Bash mostly because I'm writing it for a lightning talk.

An image built from the `Dockerfile` in this repository is available on Docker Hub as [`jnewland/kubernetes-pod-chaos-monkey`](https://hub.docker.com/r/jnewland/kubernetes-pod-chaos-monkey/).

### Configuration

A few environment variables are available for configuration:

* `DELAY`: seconds between selecting and deleting a pod. Defaults to `30`.
* `NAMESPACE`: the namespace to select a pod from. Defaults to `default`.
* `TAG` and `VALUE`: can be set to choose a specific pod within all your deployments. For example if you tag your app like frontend and backend and only want to apply the chaos on the frontend.

Example Kubernetes config is included at [`config/kubernetes/production/deployment.yaml`](./config/kubernetes/production/deployment.yaml)

### Example

From this manifest:

```
        - name: TAG
          value: name
        - name: VALUE
          value: node-micro
        - name: NAMESPACE
          value: default
        - name: DELAY
          value: '30'
```

You will see something like this 

```bash
$ kubectl apply -f config/kubernetes/production/deployment.yaml
deployment "kubernetes-pod-chaos-monkey" created
$ kubectl get pods | grep chaos
kubernetes-pod-chaos-monkey-3294408070-6w6oh   1/1       Running       0          19s
$ kubectl logs kubernetes-pod-chaos-monkey-3294408070-6w6oh
+ : 30
+ : default
+ true
+ kubectl --namespace default -o 'jsonpath={.items[*].metadata.name}' get pods --selector=name=node-micro
+ shuf
+ xargs -t --no-run-if-empty kubectl --namespace default delete pod
+ tr ' ' '\n'
+ head -n 1
kubectl --namespace default delete pod node-micro-696b7b46f5-7bzj2 
pod "node-micro-696b7b46f5-7bzj2" deleted
+ sleep 30
```

## License

[MIT](./LICENSE.md)
