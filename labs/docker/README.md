

## Run an ASP.NET container

docker run -d -p 8081:80 nginx:alpine 

> browse


docker ps

docker logs


docker run -it -p 8082:80 mcr.microsoft.com/dotnet/aspnet:6.0


> browse 

## Runtime & SDK images

docker run -it --entrypoint sh mcr.microsoft.com/dotnet/aspnet:6.0

dotnet --version

dotnet --list-sdks

exit


docker run -it --entrypoint sh mcr.microsoft.com/dotnet/sdk:6.0

dotnet --version

dotnet --list-sdks

exit

## Build .NET apps in containers

_Hello world console app_

- Dockerfile
- csproj file
- Program.cs

docker build -t dotnet-hello-world ./src/hello-world

docker run dotnet-hello-world 

_ASP/NET Razor app_

- Dockerfile
- csproj file
- Index.cshtml

docker build -t aspnet-hello-world ./src/hello-world-web

docker run -d -p 8084:80 dotnet-hello-world 

> browse localhost:8084

## Lab

run the app to show a different environment name

docker run -d -p 8085:80 -e APP_ENVIRONMENT=prod dotnet-hello-world 

> browse localhost:8085