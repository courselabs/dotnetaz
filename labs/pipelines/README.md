# Automating Deployments

Azure DevOps has lots of built-in tasks you can use to simplify your pipelines - you can build .NET apps, build Docker images, work with Key Vault storage. Those are all great but they mean your pipeline only works when you run it in Azure DevOps. An alternative approach is to put all your logic in PowerShell or Bash scripts in your source repo, and just use the pipeline to run those scripts. You don't make full use of all the features in Azure DevOps but it means you can run the scripts locally and if you move to a different service like GitHub Actions, you don't need to rewrite all your logic.

## Reference

- [Pipeline task index](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/?view=azure-devops)

- [Bash task reference](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/bash?view=azure-devops)

- [Azure CLI task reference](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/deploy/azure-cli?view=azure-devops)

## Scripts and Pipeline Parameters

To make your pipelines as flexible as possible, you'll want to parameterize them so you can run the same pipeline with different settings. The pipeline syntax separates _parameters_ which appear in the UI and _variables_ which can be computed. Variable values can be copied from parameters, and they get surfaced as environment variables inside scripts:

- [labs/pipelines/pipelines/parameters.yml](labs/pipelines/pipelines/parameters.yml) - sets up some parameters and variables, with tasks to install PowerShell and run a simple PowerShell script

📋 Create a new pipeline using this definition and run it. What is the job output?

<details>
  <summary>Not sure?</summary>

Remember new pipelines need to be created in the DevOps UI. Open the Pipelines menu and click _New pipeline_. Follow the setup to use your git repo in Azure DevOps and set the path to `labs/pipelines/pipelines/parameters.yml`.

When you first create a pipeline you can run it, but you don't see the normal UI and it will fail because all parameters are required and one of them doesn't have a default value in the YAML.

</details><br/>

Click to run the pipeline again. How do the parameters show in the UI? When you set them all and run the pipeline, you'll see the output. It just prints the values you selected, but it shows how pipeline parameters can be propagated to PowerShell scripts.


## Use the Azure CLI in a Pipeline

Now we're ready to start building pipelines which run scripts to create and manage Azure resources with the Azure CLI.

But first we need to connect Azure DevOps with our Azure Subscription, so we can authenticate the `az` command and our scripts have permission to create resources.

You do that by creating a _service connection_ in Azure DevOps. [Follow this guide](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/connect-to-azure?view=azure-devops#create-an-azure-resource-manager-service-connection-using-automated-security) to create an Azure Resource Manager service connection and call it `spn-az-devops`

📋 Open the service connection details in Azure DevOps - there's a link to see the security roles in the Azure Portal. What role does the service connection have?

<details>
  <summary>Not sure?</summary>

Open _Project settings_ and then _Service connections_. Under _Azure Resource Manager_ you'll see your connection and you can click _Manage service connection roles_ to go to the Azure Portal.

You're taken to the generic roles page, which isn't very helpful. Click on _Role Assignments_ and search for `dotnetaz`. You'll see your service connection with a random name containing the project name.

It's been assigned the _Contributor_ role

</details><br/>

> Automatically creating a service connection sets up a generic role for you. If you need more control you can manually create the identity in Azure first and then associate it with your DevOps project - that lets you assign more restricted or more generous roles.

The Azure CLI task is one you do want to use - it runs a PowerShell or Bash script, but it authenticates the Azure CLI first using your service connection:

- [labs/pipelines/pipelines/run-azure-cli.yml](labs/pipelines/pipelines/run-azure-cli.yml) - uses the task to run a PowerShell script which prints your Azure accounts 

📋 Create and run a new pipeline using this definition. Does it authenticate to Azure correctly?

<details>
  <summary>Not sure?</summary>

Create a new pipeline and set the path to `labs/pipelines/pipelines/run-azure-cli.yml`.

When the run completes you should see the list of your Azure subscriptions in the output.

</details><br/>

The service connection has permission to create resources, so everything we've done with `az` commands we can now do in pipelines.

## Provisioning Azure resources in a Pipeline

This script creates the resources we would need to deploy a containerized application:

- [labs/pipelines/scripts/create-services.ps1](labs/pipelines/scripts/create-services.ps1)

If you're not familiar with PowerShell, it should still be fairly clear what's happening. We create an RG, then an ACR instances to store images and then an AKS cluster. The `echo` commands will print friendly output in the job and because all the options use environment variables we can run the same script locally.

This pipeline sets up parameters for all the variables and then runs the PowerShell script within an Azure CLI task:

- [labs/pipelines/pipelines/create-services.yml](labs/pipelines/pipelines/create-services.yml)

📋 Create a new pipeline using this definition. Run it and supply parameters to create a 2-node cluster. Monitor the output to check everything runs.

<details>
  <summary>Not sure how?</summary>

Create a new pipeline and set the path to `labs/pipelines/pipelines/create-services.yml`.

When you run it you can choose a region and VM size as well as selecting the number of nodes.

</details><br/>

The job should run successfully or if it fails you'll see a clear error message in the job logs. When it's run you can browse to the Azure Portal and you'll see your new RG - if you didn't change the name in the pipeline parameters it will be `labs-pipeline`. In there you'll see the ACR instance and the AKS cluster. 

## Lab

This setup isn't quite ready to use though. You can push Docker images to your ACR instance if you login, but the AKS cluster needs to be configured so it can use that ACR instance to pull images. Check the [az acr]() commands to see how you can attach the ACR instance to the AKS cluster and add the command you need to the `create-services.ps1` script. Run the pipeline again - does it work?

> Stuck? Try [hints](hints.md) or check the [solution](solution.md).

___

## Cleanup

**Don't delete the RGs if you're continuing with the hackathon - if you do then there will be no VMs for Azure DevOps to use for pipeline runs, and no AKS cluster to deploy to**

If you're not continuing, then you can delete the RG that the pipeline created and the RG with the DevOps VMs:

```
az group delete -y -n labs-devops

az group delete -y -n labs-pipeline
```
