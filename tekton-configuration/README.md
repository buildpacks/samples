# Tekton Setup

To set up and use the buildpacks task with [Tekton][tekton], follow these steps:


* Setup a k8s cluster
  * For local testing, you can use a local k8s cluster, by:
    * Docker > Preferences > Kubernetes > Enable Kubernetes > Apply & Restart
    * `kubectl config current-context` should be `docker-desktop`
* Install tekton
  * `kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml`
* Install tekton dashboard
  * `kubectl apply --filename https://storage.googleapis.com/tekton-releases/dashboard/latest/tekton-dashboard-release.yaml`
  * Watch until all pods are running: `kubectl get pods --namespace tekton-pipelines --watch`
  * `kubectl --namespace tekton-pipelines port-forward svc/tekton-dashboard 9097:9097`
  * navigate to: localhost:9097
* Install latest [buildpacks task][buildpacks-task]
  * `kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/buildpacks/0.1/buildpacks.yaml`
* Install latest [git-clone task][git-clone-task]
  * `kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/git-clone/0.2/git-clone.yaml`
* Apply resources
  * Change `image/value` to your desired value
  * `kubectl apply -f resources.yaml`
* Apply auth
  * Add your registry credentials to `auth.yaml`
  * `kubectl apply -f auth.yaml`
* Apply pipeline and pipeline run
  * `kubectl apply -f run.yaml`
* See task succeed (a successful run takes about 4 minutes on the first run and about 30 seconds to a minute on subsequent runs)
  * `kubectl describe taskrun example-run`
* See output image written to registry
  * `docker pull some-output-image`

### Cleanup

* `kubectl delete taskrun --all`
* `kubectl delete pvc --all`
* `kubectl delete pv --all`


[tekton]: https://github.com/tektoncd/pipeline#-tekton-pipelines
[buildpacks-task]: https://github.com/tektoncd/catalog/tree/master/task/buildpacks/0.1
[git-clone-task]: https://github.com/tektoncd/catalog/tree/master/task/git-clone
