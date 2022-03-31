# Azure Container Registry

## Reference
- 


- [`az acr` commands](TODO)



## Explore ACR in the Portal

- create a resource
- search 'Container Registry'

- replication
- authentication


## Create an ACR instance with the CLI

az group create -n labs-acr -l westeurope --tags courselabs=dotnetaz

> need to find a unique name for the domain

  az acr create -g labs-acr --location westeurope -n $acrName --sku 'Basic'   --admin-enabled 'true' 

docker image pull nginx:alpine

docker image tag nginx:alpine my-acr.azurecr.io/labs-acr/nginx:alpine-2204

docker image ls 

# this will fail

docker image push my-acr.azurecr.io/labs-acr/nginx:alpine-2204

az acr login

# now works

docker image push my-acr.azurecr.io/labs-acr/nginx:alpine-2204

docker run -d -p 8080:80 my-acr.azurecr.io/labs-acr/nginx:alpine-2204

## Build & push a custom image

docker build -t  my-acr.azurecr.io/labs-acr/aspnet-hello-world:6.0 ./src/hello-world-web

docker tag my-acr.azurecr.io/labs-acr/aspnet-hello-world:6.0  my-acr.azurecr.io/labs-acr/aspnet-hello-world:latest

docker image ls my-acr.azurecr.io/*

docker push --all-tags my-acr.azurecr.io/labs-acr/hello-world-web

## Browse to ACR in portal  

- repository list
- tags & sha
- tasks

## Lab

Loop to delete oldest tags in repo

