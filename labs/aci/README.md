# Azure Container Instances

The great thing about Docker containers is they're portable - your app runs in the same way on Docker Desktop as it does on any other container runtime. Azure offers several services for running containers, and the simplest is Azure Container Instances (ACI) which is a managed container service. You run your apps in containers and you don't have to manage any of the underlying infrastructure.

## Reference

- [Container Instanceas documentation](https://docs.microsoft.com/en-gb/azure/container-instances/)

- [`az container` commands](https://docs.microsoft.com/en-us/cli/azure/container?view=azure-cli-latest)


## Explore Azure Container Instances

Open the Portal and search to create a new Container Instance resource. Look at the options available to you:

- the image rfegistry to use - it could be your own ACR instance or a public registry like Docker Hub
- the container image to run
- the compute size of your container - number of CPU cores and memory
- in the networking options you can publish ports and choose a DNS name to access your app
- in the advanced options you can set environment variables for the container

You can run Linux and Windows containers with ACI, so you can run .NET Core and .NET Framework apps. The UX is the same - we'll see how the service works using the command line.

## Create ACI group with the CLI

Start with a new Resource Group for the lab, using your preferred region:

```
az group create -n labs-aci --tags courselabs=dotnetaz -l eastus
```


- create group
- run container in group
- get URL
- get logs


## Deploy to ACI from Docker

- login
- switch context
- docker ps - doesn't show existing

- docker run
- docker logs
- docker ps

## Lab

OS/arch matching - what happens if you try to run this container in ACI:

:linux-arm64

(arm image)

which image tag should you use? - find on hub, multi-arch or intel