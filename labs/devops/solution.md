# Lab Solution

In my sample solution I've added another task to list accounts:

- [labs/devops/lab/audit-tools-vmss.yml](labs/devops/lab/audit-tools-vmss.yml)

The pipeline is set up with a branch trigger, so when you push changes it will start a pipeline run.

You can copy the YAML from the solution into the original file and then push your changes:

```
git add --all

git commit -m 'DevOps lab'

git push devops main
```

That uploads your changes which will trigger a new pipeline run.

**It will fail**. The `az` command is installed in your VM, but it's not authenticated so you can't run any commands against your subscription.