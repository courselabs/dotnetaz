# Virtual Networks

## Reference

- [Virtual Network overview](https://docs.microsoft.com/en-gb/azure/virtual-network/virtual-networks-overview)

- [`az keyvault` commands](https://docs.microsoft.com/en-us/cli/azure/keyvault?view=azure-cli-latest)

- [`az ketvault secret` commands](https://docs.microsoft.com/en-us/cli/azure/keyvault/secret?view=azure-cli-latest)



## Explore Virtual Networks in the Portal

- create a resource
- search 'Virtual network'
- IP addresses - a range for the whole vnet, then subnet ranges
- used to isolate workloads, eg. Kubernetes can access storage account but not Hadoop


## Create a Virtual Network with the CLI


- two subnets

## Create Virtual Machines in the VNet

- one in each subnet
- get privat IP addresses

## Connect to the VM

- get PIP
- ssh
- ping to other VM

## Lab

You might not want to leave port 22 open permanently. How can you filter traffic so port 22 is blocked? (NSG)