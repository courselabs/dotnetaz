# Resource Groups

## Reference

- [Resource Groups](https://docs.microsoft.com/en-gb/azure/azure-resource-manager/management/overview#resource-groups)
- [Regions]
- [`az group` commands](https://docs.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest)


## Create a new RG in the portal

- name dotnetaz-1
- region
- add tag: lab=resourcegroups

> Recommended vs. Other regions


## Create an RG with the Azure CLI

az group create --help


How can you find the list of regions?

az account list-locations -o table

az group create -n dotnetaz-2 -l westeurope --tags lab=resourcegroups


## Manage Resource Groups

az group list -o table 

az group list -o table --query "[?tags.lab == 'resourcegroups']"

## Delete Resource Groups

```
# fails
az group delete --query "[?tags.lab == 'resourcegroups']"
```

az group delete -n dotnetaz-1

## Lab

Delete remaining group(s) with a one-line CLI command

hint - 

az group list -o tsv --query "[?tags.lab == 'resourcegroups']" 

az group list -o tsv --query "[?tags.lab == 'resourcegroups'].name"

az group list -o tsv --query "[?tags.lab == 'resourcegroups'].name" | foreach { az group delete -n $_ -y }

