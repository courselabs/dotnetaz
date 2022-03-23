# Azure Key Vault

## Reference
- 


- [`az keyvault` commands](https://docs.microsoft.com/en-us/cli/azure/keyvault?view=azure-cli-latest)

- [`az ketvault secret` commands](https://docs.microsoft.com/en-us/cli/azure/keyvault/secret?view=azure-cli-latest)



## Explore Key Vault in the Portal

- create a resource
- search 'KeyVault'
- key features: soft-delete, access policy


## Create a Key Vault with the CLI

az group create -n labs-keyvault -l westeurope --tags courselabs=dotnetaz

> needs a globally unique name

az keyvault create -l westeurope -g labs-keyvault -n kv-01 --retention-days 7

az keyvault create -l westeurope -g labs-keyvault -n sc-kv01-2003 --retention-days 7


## Manage Secrets in the Portal

browse to your new keyvault

create a secret with the key `sql-password` which we could use to store credentials

- is the UX clear?
- when you create the secret, how do you view it again?
- what happens if you need to update the secret?

> create a new version

## Manage Secrets in the CLI

Secrets have a unique ID which contains the keyvault name, secret name and version. Copy the ID of the latest version of your secret - e.g. `https://sc-kv01-2003.vault.azure.net/secrets/sql-password/9989912ad43d4588971d9db2184990a6`

You can show the secret using just the ID:

```
az keyvault secret show --id https://sc-kv01-2003.vault.azure.net/secrets/sql-password/9989912ad43d4588971d9db2184990a6
```

for scripting, youy might want to add output and query parameters, so you just show the value:

az keyvault secret show -o tsv --query "value" --id https://sc-kv01-2003.vault.azure.net/secrets/sql-password/9989912ad43d4588971d9db2184990a6


If you don't know the ID, you can get the latest version by name:

az keyvault secret show --vault-name sc-kv01-2003 --name sql-password

Update the secret:

az keyvault secret set --name sql-password --vault-name sc-kv01-2003 --value pw124123v4

Check versions:

az keyvault secret list-versions --name sql-password --vault-name sc-kv01-2003 

> Doesn't show values

## Lab

Often you want to restrict access to the Keyvault so it can only be read during deployments.

How can you lock down the keyvault?