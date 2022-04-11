# Running a Local Kubernetes Cluster

Kubernetes clusters can have hundreds of nodes in production, but you can run a single-node cluster on your laptop and it works in the same way.

We'll also use [Git](https://git-scm.com) for source control, so you'll need a client on your machine to talk to GitHub.

## Git Client - Mac, Windows or Linux

Git is a free, open source tool for source control:

- [Install Git](https://git-scm.com/downloads)

## Azure Subscription

You'll need your own Azure Subscription, or one which you have _Owner_ permissions for:

- [Create a free subscription with $200 credit](https://azure.microsoft.com/en-gb/free/)

## Azure Command Line - Mac, Windows or Linux

The `az` command is a cross-platform tool for managing Azure resources:

- [Install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)


## Docker Desktop - Mac, Windows or Linux

If you're on macOS or Windows 10 Docker Desktop is the easiest way to get Kubernetes:

- [Install Docker Desktop - Mac or Windows](https://www.docker.com/products/docker-desktop)

- [Install Docker Desktop - Linux beta version](https://docs.docker.com/desktop/linux/#download-and-install)

The download and install takes a few minutes. When it's done, run the _Docker_ app and you'll see the Docker whale logo in your taskbar (Windows) or menu bar (macOS).

> On Windows 10 the install may need a restart before you get here.

Right-click that whale and click _Settings_:

![](/img/docker-desktop-settings.png)

In the settings Windows select _Kubernetes_ from the left menu and click _Enable Kubernetes_: 

![](/img/docker-desktop-kubernetes.png)

> Docker downloads all the Kubernetes components and sets them up. That can take a few minutes too. When the Docker logo and the Kubernetes logo in the UI are both green, everything is running.

## Check your setup

When you're done you should be able to run these commands and get a response with no errors:

```
git version

az --version

docker version

kubectl version
```

> Don't worry about the actual version numbers, but if you get errors then we need to look into it.