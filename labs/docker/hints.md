# Lab Hints

You can specify configuration in .NET 6.0 apps using lots of different data sources. The default settings are packaged in the container image in the `appsettings.json` file, which is where the environment name `DEV` comes from. You can override that at runtime with an environment variable.

Check the Docker documentation (or help text in the CLI) to see how to set an environment variable for a container. Then you need to map the config key for your run command.

> Need more? Here's the [solution](solution.md).