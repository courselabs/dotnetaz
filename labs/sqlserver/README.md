# SQL Azure

## Reference
- 


- [`az sql server` commands](https://docs.microsoft.com/en-us/cli/azure/sql/server?view=azure-cli-latest)

- [`az sql db` commands](https://docs.microsoft.com/en-us/cli/azure/sql/db?view=azure-cli-latest)


## Explore Azure SQL in the Portal

- create a resource
- search 'Azure SQL'
- types, why so many choices?

- select a single SQL database
- walk through the options, what resources do you need?

> database lives in a SQL Server, which lives in a resource group; you can typically create dependent resources directly in the portal

- authentication types - sql auth is in fashion again, makes non-Windows/non-AD client connections easier


## Create a SQL Database with the CLI

az group create -n labs-sqlserver -l westeurope --tags courselabs=dotnetaz

az sql server create -l westeurope -g labs-sqlserver -n sql-labs-01 -u sqladmin -p abc01234[]

> this will take a while; check the docs to answer this:

- what cost is a SQL Server with no databases?
- 

