# Hackathon!

The hackathon is your chance to spend some decent time modelling and deploying a .NET app with cloud native technologies on Azure.

You'll use all the key skills you've learned in the course, and:

- 😣 you will get stuck
- 💥 you will have errors and failures
- 📑 you will need to research and troubleshoot

**That's why the hackathon is so useful!** 

It will help you understand which areas you're comfortable with and where you need to spend some more time.

And it will give you an app that you modelled yourself, which you can use as a reference next time you migrate a .NET app to Docker and Azure.

> ℹ There are several parts to the hackathon - you're not expected to complete them all. In some classes we have a whole day for this, in others just a few hours. Get as far as you can in the time, it's all great experience.

## Part 1 - Welcome to RNG

RNG is our sample app - it's a Random Number Generator. It's written in .NET 6.0 so it's good to run in containers on Linux.

Here's the architecture diagram:

![](/img/hackathon-architecture.png)

It's not much to go on, but it has all the information you need for the first stage.

There are two components to the app, each will need its own Docker image. The source code is in the `project/src` folder, and each component has a Dockerfile which needs to be completed in the `project/docker` folder:

- RNG API - an ASP.NET REST API which generates random numbers - [api/Dockerfile](.project/docker/api/Dockerfile)

- RNG website - an ASP.NET web app which uses the API to show random numbers - [web/Dockerfile](./project/docker/web/Dockerfile)

You should be able to get the components to build without any errors.

🥅 Goals

- Build a Docker image for each component

- Run a container from each image

- Verify you can make an HTTP call and get a response from each container

- **You don't need to network the containers together and get the whole app working correctly at this stage**

<details>
  <summary>💡 Hints</summary>

The build steps are already written in the Dockerfiles, so your first job is to find the right base images from Docker Hub.

When you build your images you'll need to run the Docker command from the right folder location - where Docker can find the `src` folder and the Dockerfiles. You'll need to explicitly state the path to the Dockerfiles.

</details><br/>

<details>
  <summary>🎯 Solution</summary>

If you didn't get part 1 finished, you can check out the sample solution from `solution/part-1`:

- [API Dockerfile](./solution/part-1/docker/api/Dockerfile)

- [Web Dockerfile](./solution/part-1/docker/web/Dockerfile)

Copy from the sample solution to the project directory - this makes a backup of your folder first:

```
mv project/docker project/docker-part1.bak

cp -r solution/part-1/docker project/
```

Then build the images - make sure you use the `hackathon/project` directory as the root directory so Docker can access the `src` and `docker` folders:

_API:_

```
docker build -t rng-api:6.0 -f ./hackathon/project/docker/api/Dockerfile ./hackathon/project

docker run -d -p 5000:80 rng-api:6.0

# test the API at http://localhost:5000/rng
```

_Website:_

```
docker build -t rng-web:6.0 -f ./hackathon/project/docker/web/Dockerfile ./hackathon/project

docker run -d -p 5001:80 rng-web:6.0

# test the app at http://localhost:5001 - you won't be able to get a random number yet
```

</details><br/>


## Part 2 - Run the app in Kubernetes locally

The app doesn't work in because the containers aren't networked together. You can do that in Docker, but we'll switch to Kubernetes so we have a declarative model for the app.

The model will need a compute part so each component runs in a Pod, and a networking part so each component can be reached with a Service. There are some YAML files in the  `project/kubernetes` folder to get you started:

- [api.yaml](./project/kubernetes/api.yaml) - defines a Deployment for the API

- [api-service.yaml](./project/kubernetes/api-service.yaml) - defines a Service for the API - **the name of the Service becomes the DNS name other Pods can use to access the Service**

- [web.yaml](./project/kubernetes/web.yaml) - defines a Deployment for the API which needs the URL for the API Service

- [web-service.yaml](./project/kubernetes/web-service.yaml) - defines a Service for the API so we can browse to it

If you complete the YAML specs you should get the app running in Kubernetes.

🥅 Goals

- Complete the compute and networking parts of the model

- Run the app on your local Kubernetes cluster

- Verify you can browse to the app and it works correctly

<details>
  <summary>💡 Hints</summary>

Remember how Pods are loosely-coupled to Services with labels and selectors. You'll need to get those right in the YAML so everything matches up.

</details><br/>

<details>
  <summary>🎯 Solution</summary>

My sample solution is in the `solution/part-2` folder. You can deploy those specs onto your cluster, but you might need to change the image names if you used different ones in your `docker build` commands:

```
kubectl apply -f .\hackathon\solution\part-2\kubernetes\
```

</details><br/>


## Part 3 - Create services in Azure

Now we have the app running locally we want to set up the Azure infrastructure. We'll use AKS to run the app and we'll need a private ACR instance to store the images. Eventually we'll build all this into a DevOps pipeline, so we want to have the steps scripted rather than use the Portal.

🥅 Goals

- Write a PowerShell or Bash script to create the Azure resources

- Verify you can connect to your AKS cluster with the Kubernetes command line

- Verify your AKS cluster has access to images on your ACR instance

<details>
  <summary>💡 Hints</summary>

This is very similar to what we did in the DevOps pipeline lab :) You can find a script there to use as a starting point. You need to create three objects in Azure and you can assume that your script will run in the context of an authenticated `az` user. Don't forget the additional step to authorize your AKS cluster to use the ACR images.

</details><br/>

<details>
  <summary>🎯 Solution</summary>

You can see my sample solution here:

- [create-services.ps1](./solution/part-3/create-services.ps1)

It uses environment variables for the parameters, but with defaults set if the environment variables are empty. 

</details><br/>


## Part 4 - Run the app in Kubernetes on Azure

With all the infrastructure in place, we can run the app in Azure and get ready for the launch date. You can deploy from your local machine to start with, but make sure the steps are scripted so we can put them in a pipeline later.

🥅 Goals

- Write a PowerShell or Bash script to build and deploy the app

- You should build images with your ACR domain in the name and push them to ACR

- Your Kubernetes model will need to use the ACR images

<details>
  <summary>💡 Hints</summary>

It's worth taking the script one step at a time, starting with the build. You can use the same Dockerfiles and the same build commands, but make sure your tag includes your ACR domain. 

When you add the push stage to your script remember you need to authenticate with ACR - you can assume that wherever the script runs it will be in the context of a logged-in `az` user.

You'll need to update the image names in your Kubernetes model, and when you add the deployment stag to your script remember that you need to get the context of your Kubernetes cluster before you can deploy.

</details><br/>

<details>
  <summary>🎯 Solution</summary>

You can see my sample solution here:

- [deploy-app.ps1](./solution/part-4/deploy-app.ps1)

It uses environment variables for the parameters, but with defaults set if the environment variables are empty. You can change those defaults and run the script to deploy - but you'll need to set your own ACR domain in the build commands and the Kuberentes YAML

</details><br/>

If you change some code and run your deployment script again, you might not see your changes live in AKS. That's because you're using the same image name so Kubernetes doesn't think there are any changes. Use a different image tag in your script and YAML and then you'll see the changes in AKS.

## Part 5 - Over to you :)

About that DevOps pipeline... 

You have everything you need now, from the application model and the infrastructure scripts to the deployment scripts. 

You should be able to automate it all, so that when a developer pushes changes, a new set ofDocker images are built and the application gets deployed to AKS.

It would be nice if the Docker image tag included an incrementing version number, so the images were stored for every build - but that will take some thinking about.