# Azure DevOps

Azure DevOps is the project management tool from Microsoft - it replaces TFS, and gives you a single home for traking work items, storing source code and running automated pipelines. It's a separate UI from the Azure Portal and it has some odd behaviour; it takes quite a few manual steps to get things set up. You only need to do that the first time you add a new project or pipeline, but the setup usually needs to be done in the web UI. 

## Reference


- [Creating a VM Scale Set to run DevOps jobs](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/scale-set-agents?view=azure-devops#create-the-scale-set)

- [Built-in Azure DevOps Pipeline Tasks](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/?view=azure-devops)

- [Azure DevOps Piplines YAML spec](https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/?view=azure-pipelines)


## Create a DevOps Organization and Project

Log in to the Azure DevOps UI:

- https://dev.azure.com/

**If you get straight to a company organization then your Microsoft ID is linked to your company DevOps. You probably won't have permission to create things so you'll want to log out and use a Microsoft ID you can link to your own Azure subscription**

Select _Start Free_ and sign in with the account you use for Azure. In the DevOps web UI click _create new_ to create a new Organization:

- choos a a unique name
- select an Azure region
- complete the Captcha

[Organizations]() are the top-level grouping. You may have one Organization for the whole company, or larger enterprises may have Organizations for different business units.

Within Orgnizations you have [Projects](); create a new Project:

- call it `dotnetaz`

Browse the new project - if you're used to TFS you'll see the familiarities:

- you can create a wiki for documentation
- create work items and track them in boards
- store source code in git repositories
- create, run and manage pipelines for automated builds and deployments

We'll push the code for the labs to DevOps and run some pipelines.

## Push the lab repo to Azure DevOps

We cloned this repository from GitHub but we can push a private copy to Azure DevOps.

Copy the commands from the section _Push an existing repository from command line_ to a text file **but don't run them yet**.

Change the name `origin` in the commands to `devops` (the original GitHub code already uses the name `origin`); so the commands you run will look like this - you'll need your own organization name:

```
git remote add devops https://<org-name>@dev.azure.com/<org-name>/dotnetaz/_git/dotnetaz

git push -u devops main
```

> A window will open asking you to sign in - use the same Microsoft ID you're using for Azure DevOps. 

Browse back to your DevOps UI and refresh the _Files_ section under _Repos_ in the left nav. Now you have your own copy of the source code in your private repo. Git preserves all the history, so you can see the commits as well as the current files.

This will be the source for your automated pipelines. When you make changes you'll do them in your local files and then push them to Azure DevOps.

## DevOps Pipelines

Pipelines can be put together in the UI or written in YAML. The YAML option is better - it gives you more control and the pipeline files lives in source control with version history.

There's a simple pipeline in this repo which just prints some tool versions:

- [audit-tools.yaml](./pipelines/audit-tools.yml)

The definition is in the repo **but you need to create the pipeline in the web UI first**:

- click _Pipelines_ nav then _Create Pipeline_
- under _Where is your code_ - select _Azure Repos Git_
- select your `dotnetaz` repository
- select _Existing Azure Pipelines YAML file_
- leave the branch as `main` and enter the path: `labs/devops/pipelines/audit-tools.yaml`
- click _Continue_ - you'll see the Pipeline YAML
- click _Run_ to run the pipeline

The pipeline will start and you can navigate through the progress.

**It will fail**. Azure DevOps can use free VMs to run pipelines, but new organizations can't use the free VMs [until you fill in a form to request access](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/hosted?view=azure-devops&tabs=yaml#capabilities-and-limitations). That could take 2-3 days, so we'll use our own VMs instead.


## Create an Azure VM Scale Set to run Pipeline Jobs

A VM Scale Set is a group of 0 or more VMs that all have the same configuration. Organizations typically use their own VMs to run DevOps pieplines because they can configure them with all the tools they need.

Azure DevOps will manage the scale set - creating more VMs when there are jobs to run and removing them when the jobs are finished, but we need to create the Scale Set first.

Start with a Resource Group in your preferred region:

```
az group create -n labs-devops --tags courselabs=dotnetaz -l eastus
```

Now create a VM Scale Set with a simple Ubuntu image:

```
az vmss create --name agentpool -g labs-devops --image UbuntuLTS --vm-sku Standard_D2_v3 --disable-overprovision --upgrade-policy-mode manual
```

> You may need to tweak the region and VM size to get something that works in your subscription.


## Set up an Agent Pool in Azure DevOps

Azure DevOps can create the VMs for us on demand, but we need to set up an _Agent Pool_, which is a pool of VMs DevOps can use to run jobs.

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

This pipeline uses the agent pool with the name `linux01`:

- [labs/devops/pipelines/audit-tools-vmss.yml](labs/devops/pipelines/audit-tools-vmss.yml)

There's more going on than in the original piprline, because we need to install the tools we want - the Microsoft hosted agents already have those installed.

We'll switch the exising pipeline to use the new definition. 


📋 Edit your existing Pipeline in the DevOps UI so it uses this YAML file instead.

<details>
  <summary>Not sure how?</summary>

The DevOps UI isn't always very friendly :)

Browse to your Pipeline, select the vertical ellipsis next to _Run pipeline_ and click _Settings_. Change the path to `labs/devops/pipelines/audit-tools-vmss.yaml`

</details><br/>

Run the Pipeline and check the output. You'll see it gets queued. Open the Azure Portal and navigate to your VM Scale Set - select the _Instances_ section and you should see VMs starting or running. These were created by Azure DevOps to run the Pipeline job.

> The job may stay as _Queued_ for a long time - the first VMs added to the scale set can take 10+ minutes. Back in the Azure DevOps UI you can return to the project settings and agent pools to see what's happening with your `linux01` agent pool.

When the job is running, check the output - you'll see all the tools being installed. Run the job again and it will finish more quickly because the tools are already there on the VM.

## Lab

Edit the pipeline steps in your YAML file to run some more `az` commands. Does the pipeline run when you've made your edits? Can you list and create resource groups in a pipeline job?

> Stuck? Try [hints](hints.md) or check the [solution](solution.md).

___

## Cleanup

**Don't delete the RG if you're continuing with the next lab - if you do then there will be no VMs for Azure DevOps to use for pipeline runs**

If you're not continuing, then you can delete the RG:

```
az group delete -y -n labs-devops
```
