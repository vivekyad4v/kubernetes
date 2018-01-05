#!/bin/bash

: ' 
If you do not already have a hypervisor installed, install one now.
For OS X, install xhyve driver, VirtualBox, or VMware Fusion, or HyperKit.
For Linux, install VirtualBox or KVM.
For Windows, install VirtualBox or Hyper-V.
' 

is_mac()
{
echo -en "Installing minikube(Minikube v0.24.1) & kubectl(latest) for MAC OS.... \n \n "
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/darwin/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.24.1/minikube-darwin-amd64 && chmod +x minikube && mv minikube /usr/local/bin/
}

is_linux()
{
echo -en "Installing minikube(Minikube v0.24.1) & kubectl(latest) for Linux OS.... \n \n "
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.24.1/minikube-linux-amd64 && chmod +x minikube && mv minikube /usr/local/bin/
}

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     is_linux ;;
    Darwin*)    is_mac ;;
    *)          echo -en "Machine UNKNOWN - ${unameOut}"
esac
