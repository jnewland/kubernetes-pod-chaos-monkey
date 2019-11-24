# Kubernetes Pod Chaos Monkey

This repository contains a `Dockerfile` and associated Kubernetes configuration for a Deployment that will randomly delete pods in a given namespace. This is implemented in Bash mostly because I'm writing it for a lightning talk.

An image built from the `Dockerfile` in this repository is available on Docker Hub as [`jnewland/kubernetes-pod-chaos-monkey`](https://hub.docker.com/r/jnewland/kubernetes-pod-chaos-monkey/).

### Configuration

A few environment variables are available for configuration:

* `DELAY`: seconds between selecting and deleting a pod. Defaults to `30`.
* `NAMESPACE`: the namespace to select a pod from. Defaults to `default`.

Example Kubernetes config is included at [`config/kubernetes/production/deployment.yaml`](./config/kubernetes/production/deployment.yaml)

### Example

```bash
$ kubectl apply -f config/kubernetes/production/deployment.yaml
deployment "kubernetes-pod-chaos-monkey" created
$ kubectl get pods | grep chaos
kubernetes-pod-chaos-monkey-3294408070-6w6oh   1/1       Running       0          19s
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

### Advance usage

The deployment can be configured to select specific pods using labels. The chaos script support both ways to refer this labels. To know more about this labels, please refer to [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api) doc.

In order to use this feature set up in the manifest this environment variables:

* `SELECTOR_MODE`: choose between _equality-based_ or _set-based_.
* `SELECTOR`: write the label selector here.

Those variables are **completely optional** and can be left without a value.

Some examples:

* with _equality-based_

```
- name: SELECTOR_MODE
  value: equality-based  
- name: SELECTOR
  value: environment=production,tier=frontend
```

* with _set-based_

```
- name: SELECTOR_MODE
  value: set-based  
- name: SELECTOR
  value: environment in (production),tier in (frontend)
```

With this changes, you'll see the following output

```bash
+ : 30
+ : default
+ true
+ kubectl --namespace default -o 'jsonpath={.items[*].metadata.name}' get pods --selector environment=production,tier=frontend
+ shuf
+ head -n 1
+ tr ' ' '\n'
+ xargs -t --no-run-if-empty kubectl --namespace default delete pod
kubectl --namespace default delete pod hello-world 
pod "hello-world" deleted
```

With _set-based_

```bash
+ : 30
+ : default
+ true
+ kubectl --namespace default -o 'jsonpath={.items[*].metadata.name}' get pods --selector 'environment in (production),tier in (frontend)'
+ shuf
+ tr ' ' '\n'
+ xargs -t --no-run-if-empty kubectl --namespace default delete pod
+ head -n 1
kubectl --namespace default delete pod hello-world 
pod "hello-world" deleted
```

## License

[MIT](./LICENSE.md)