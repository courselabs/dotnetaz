
## Reference

- [Built-in Azure DevOps Pipeline Tasks](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/?view=azure-devops)

- [Azure DevOps Piplines YAML spec](https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/?view=azure-pipelines)

## Create DevOps Organization & Project

separate UI from azure

https://dev.azure.com/

_Start Free_

Sign in with same Az account; DevOps web ui opens; you may have organizations already available, click _create new_ and create an org with a unique name

Five your org a name, select a region and complete the captcha

create a project - call it dotnetaz

browse - if you're used to TFS this is the replacement:

- docs in wiki
- work tracking in boards
- repos are git repositories
- pipelines for automated deployments


## Push the lab repo to Azure DevOps

We cloned this repository from GitHub but we can push a private copy to Azure DevOps.

Copy the commands from the section _Push an existing repository from command line_ to a text file **but don't run them yet**.

Change the name `origin` in the commands to `devops` (the original GitHub code already uses the name `origin`); so the commands will like this - you'll need your own organization name:

```
git remote add devops https://<org-name>@dev.azure.com/<org-name>/dotnetaz/_git/dotnetaz

git push -u devops --all
```

> A window will open asking you to sign in - use the same Microsoft ID you're using for Azure DevOps. 

Browse back to your DevOps UI and refresh the _Files_ section under _Repos_ in the left nav. Now you have your own copy of the source code in your private repo. Git preserves all the history, so you can see the commits as well as the current files.

This will be the source for your automated pipelines. When you make changes you'll do them in the local files and then push them to Azure DevOps.

## DevOps Pipelines

Pipelines can be put together in the UI or written in YAML. The YAML option is better - it gives you more control and the pipeline files lives in source control with version history.

There's a simple pipeline in this repo which just prints some tool versions:

- [audit-tools.yaml]

The definition is in the repo, but you need to create the pipeline in the web UI:

- click _Pipelines_ nav then _Create Pipeline_
- where is your code - selec _Azure Repos Git_
- select your `dotnetaz` repository
- select _Existing Azure Pipelines YAML file_
- leave the branch as `main` and enter the path: `labs/devops/pipelines/audit-tools.yaml`
- click _Continue_ - you'll see the Pipeline YAML
- click _Run_ to run the pipeline

The pipeline will start and you can navigate through the progress.

It will fail though, because new organizations can't use Microsoft-hosted VMs to run jobs [until you fill in a form to request access](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/hosted?view=azure-devops&tabs=yaml#capabilities-and-limitations). That could take 2-3 days, so we'll use our own VMs instead.


## Create an Azure VM Scale Set to run Pipeline Jobs

A VM Scale Set is a group of 0 or more VMs that all have the same configuration. Azure DevOps will scale up the VMs when there are jobs to run and scale down when the jobs are finished, but we need to create the Scale Set first.

```
az group create -n labs-devops --tags courselabs=dotnetaz -l eastus
```


```
az vmss create --name agentpool -g labs-devops --image UbuntuLTS --vm-sku Standard_D2_v3 --disable-overprovision --upgrade-policy-mode manual
```

> https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/scale-set-agents?view=azure-devops#create-the-scale-set



Azure DevOps can create the VMs for us on demand, but we need to set up an _Agent Pool_.

- click on _Project Settings_ in the bottom-left of your screen
- under _Pipelines_ select _Agent Pools_  - you'll see the default Azure Pipelines which we can't use
- click _Add pool_ and set the type to _Azure virtual machine scale set_
- select your Azure subscription and click _Authorize_

When authorization completes, set up the pool:

- select your VM Scale Set called `agentpool`
- call the agent pool `linux01`
- set the maxmimum number to `2`, the number on standby to `1` and the delete delay to `5` minutes
- be sure to select _Grant access permission to all pipelines_
- click _Create_

This [Pipeline YAML]() uses the agent pool with the name `linux01`.

Browse to your Pipeline, select the ellipsis next to _Run pipeline_ and click _Settings_. Change the path to `labs/devops/pipelines/audit-tools-vmss.yaml`

Run the Pipeline and check the output. You'll see it gets queued. Open the Azure Portal and navigate to your VM Scale Set - select the _Instances_ section and you should see VMs starting or running. These were created by Azure DevOps to run the Pipeline job.

The job may stay as _Queued_ for a long time - the first VMs added to the scale set can take 10+ minutes. Back in the Azure DevOps UI you can return to the project settings and agent pools to see what's happening with your `linux01` agent pool.

## Lab

Edit the pipeline steps, push changes and watch in DevOps - does a new job get queued automatically?

