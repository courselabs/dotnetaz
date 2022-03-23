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

> need to find a unique name for the server 

az sql server create -l westeurope -g labs-sqlserver -n sql-labs-01 -u sqladmin -p abc01234[]

> this will take a while; check the docs to answer this:

- what cost is a SQL Server with no databases?
- 

Browse to the portal, find the server properties. Can you see why the server name needs to be globally unique?

> DNS name for access, e.g. sql-labs-03.database.windows.net

 az sql db create -s sql-labs-03 -g labs-sqlserver -n db01

> this will take a couple of minutes; check the portal to see the status

- what is the default size for a new db? (small)


## Connect to the Database

The portal view for SQL Databases shows connection strings. Use that to connect to the database with a SQL client

- you can usee Visual Studio or SQL Server Management Studio if you have them
- or the SQL Server Extension for VS Code
- or a simple client like [SQLEctron](https://github.com/sqlectron/sqlectron-gui/releases/tag/v1.32.1) (don't download a newer version than 1.32 because of [issue 699](https://github.com/sqlectron/sqlectron-gui/issues/699))

Try to connect with the SQL Server credentials - can you access the database?

You'll see an error like this:

_Cannot open server 'sql-labs-03' requested by the login. Client with IP address '216.213.184.119' is not allowed to access the server. To enable access, use the Windows Azure Management Portal or run sp_set_firewall_rule on the master database to create a firewall rule for this IP address or address range. It may take up to five minutes for this change to take effect._

SQL Server has an IP block, so you need to explicitly allow access to clients.

In the portal, open the SQL Server instance and find the firewall settings. On that page add your own IP address to the rules, so you will be allowd access - then try the connection again.

## Query the Database

You're an admin so you can run DDL and DML statements:

CREATE TABLE students (id INT IDENTITY, email NVARCHAR(150))

INSERT INTO students(email) VALUES ('elton@sixeyed.com')

SELECT * FROM students

## Lab

Use AZ CLI to delete the database. THe SQL Server still exists - can you retrieve the data? Now delete the resource group, does the Server still exist?

az sql db delete --name db01 --resource-group labs-sqlserver --server sql-labs-03

az group delete -y -n labs-sqlserver 