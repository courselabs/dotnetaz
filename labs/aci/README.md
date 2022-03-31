

## Explore Azure Container Instances

- portal

- select OS
- choose image
- select size (windows/linux disparity)

- ports
- environment settings

## Create ACI group with the CLI

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