# Kubernetes for beginners
<a href="https://github.com/vivekyad4v?tab=followers"><img align="right" width="200" height="183" src="https://s3.amazonaws.com/github/ribbons/forkme_left_green_007200.png" /></a>

You need to have basic understanding about docker & kubernetes -
https://en.wikipedia.org/wiki/Kubernetes
https://en.wikipedia.org/wiki/Docker_(software)

## Install minikube (Works for Linux & MAC OS) - 

```sh
$ chmod +x install-minikube.sh
$ ./install-minikube.sh
```

### Build & push images -

```sh
$ docker-compose build
$ docker-compose push
```

### Deploy images to Docker Swarm - 

```sh
$ docker swarm init
$ docker stack deploy -c docker-compose.yml SIMPLE-WEB --with-registry-auth
$ docker stack services SIMPLE-WEB
$ docker ps 
```

Goto `http://localhost` to view swarm loadbalancing behaviour, you will see it's balancing the load across two Nginx containers & Nginx is acting as a LB for python containers.

### Deploy images to kubernetes 

We got to provide our registry creds to k8s cluster for a successful image fetch - 

```sh
$ export USERNM=vivekyad4v                                  # Registry username
$ export PASSWD=ab1234                                      # Registry passowrd
$ export AUTH_TOKEN=$(echo -n "$USERNM:$PASSWD" | base64)   # Your registry auth token
```

Create secret -

```sh
$ kubectl create secret docker-registry regsecret --docker-server=https://index.docker.io/v1/ --docker-username=$USERNM --docker-password=$PASSWD --docker-email=vivekyad4v@gmail.com
```

Deploy images - 

```sh
$ kubectl create -f deployment.yml
$ kubectl get deployment                     
$ kubectrl get all                           # GET everything
$ eval $(minikube docker-env) && docker ps   # View deployed containers
```

Minikube dashboard - 

```sh
$ minikube dashboard                 # View minikube dashboard in your browser
$ minikube service nodexpose --url   # Goto URL, paste this IP:Port in your browser 
```

Goto the `$ minikube service nodexpose --url` URL to view Kubernetes loadbalancing behaviour, you will see it's balancing the load across two Nginx containers & Nginx is acting as a LB for python containers.


## Destroy everything -

```sh
$ docker stack rm SIMPLE-WEB
$ kubectl delete -f deployment.yml
$ minikube stop
$ minikube delete
```

### Take away -

Docker Swarm seems to be less complex than Kubernetes but when it comes to control, coupling & extensibility Kubernetes wins the race by a fair margin.


