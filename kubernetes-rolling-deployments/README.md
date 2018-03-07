# Kubernetes Continuous | rolling deployments 
- (Rolling Deployment + HealthChecks + Scaling + AutoScaling)
##### Tech Stack
- Docker(engine, compose & swarm), Minikube, Kubernetes

### Install minikube (Works for Linux & MAC OS) - 
```sh
$ chmod +x install-minikube.sh
$ ./install-minikube.sh
```

- Minikube dashboard -
```sh
$ minikube dashboard                 # View minikube dashboard in your browser
$ minikube service nodexpose --url   # Goto URL, paste this IP:Port in your browser
```

### Install heapster addon to monitor cluster
- Heapster dashboard -
```sh
$ minikube addons list		      # View addons list
$ minikube addons enable heapster     # Enable heapster for monitoring
$ minikube addons open heapster       # View minikube dashboard in your browser
```

### Deploy images to kubernetes 
- We got to provide our registry creds to k8s cluster for a successful image fetch - 
```sh
$ export USERNM=vivekyad4v                                  # Registry username
$ export PASSWD=ab1234                                      # Registry passowrd
$ export AUTH_TOKEN=$(echo -n "$USERNM:$PASSWD" | base64)   # Your registry auth token
```

- Create secret -
```sh
$ kubectl create secret docker-registry regsecret --docker-server=https://index.docker.io/v1/ --docker-username=$USERNM --docker-password=$PASSWD --docker-email=vivekyad4v@gmail.com
```

- Continuous | Rolling deployments - 
```sh
$ export VERSION=$BUILD_NUMBER                            # Your image tag(BUILD_NUMBER)
$ docker-compose build   
$ docker-compose push
$ sed -e "s/\${VERSION}/${VERSION}/" -e "s/DEPLOYMENT_DATE/$(date)/" deployment.yml.tmpl > deployment.yml
$ kubectl apply -f deployment.yml
```

### What above code does - 
1. Exports a shell variable `BUILD_NUMBER`, this can be a value which you want to tag to your images
2. Docker compose build the images from Dockerfile. 
3. Docker compose push the images to the registry.
4. Update the docker images tag & deployment date to the k8s deployment yml file.
5. Deploy/Apply the deployment file to the cluster.
   - Create new pods.
   - Perform HTTP Healthcheck on the containers.
   - If HealthCheck passed, terminate old pods.
   - Else, don't terminate the old pods.

#### View deployment strategy - 
```sh
$ kubectl describe deployment
```
`RollingUpdateStrategy:  25% max unavailable, 25% max surge`
- Most of the time the default strategy works well, however you can always change it if required.
Ref - https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment


### Scaling -

- You can always update the `minReplicas` section within in `deployment.yml.tmpl` to scale pods horizontally.

### Test Autoscaling - 

 - HPA will automatically adjust the Replica's based on CPU Utilization - 
```sh
$ kubectl describe hpa
$ kubectl run -i --tty load-generator --image=busybox /bin/sh
$ while true; do wget -q -O- http://nodexpose; done
$ watch kubectl get hpa                              ## Run this in another tty to view autoscaling actions
```

## Destroy everything -

```sh
$ docker-compose down -v
$ kubectl delete -f deployment.yml
$ minikube stop
$ minikube delete
```

### Take away -
 - We can use this script/logic for Continuous | Rolling deployments with HTTP healthcheck & autoscaling of pods.

### Next Steps - 
- Continuous | Rolling deployments with multiple worker nodes.

