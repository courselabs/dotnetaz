# Lab Solution

In my sample solution I've added the `az aks update` command, with the `attach-acr` parameter:

- [labs/pipelines/lab/create-services.ps1](labs/pipelines/lab/create-services.ps1)

You can edit your pipeline YAML to use that script file instead, or edit the existing script in `labs/pipelines/scripts/create-services.ps1`. 

Then push your changes:

```
git add --all

git commit -m 'Pipelines lab'

git push devops main
```

That uploads your changes. This pipeline doesn't have an automatic trigger, so you'll need to run it manually.

**It will (probably) fail**. The DevOps service connection has the `Contributor` role which isn't enough to set permissions for ACR; you'll see an error like this:

_ERROR: Could not create a role assignment for ACR. Are you an Owner on this subscription?_

The service connection isn't an owner, but you are. Run the command from the script in your own terminal and it will succeed:

```
# if you changed the names in your run, you'll need to update them here too:

az aks update -g labs-pipeline -n labs-pipeline-aks01 --yes --attach-acr <acr-name>
```

When it completes you can [check](https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az-aks-check-acr) the AKS cluster does have access to ACR:

```
# you need the FQDN for your ACR instance here:

az aks check-acr -g labs-pipeline -n labs-pipeline-aks01 --acr <acr-name>.azurecr.io
```
