

## Explore in portal

## Create in CLI

- create rg

- TODO - minimal deployment

 az aks create -g $rgName -n $aksClusterName `
    --location $location `
    --node-count $aksNodeCount `
    --node-vm-size $aksNodeVmSize `
    --kubernetes-version $kubernetesVersion `
    --load-balancer-sku Standard `
    --network-plugin azure `
    --no-ssh-key `
    --network-plugin azure `
    --vnet-subnet-id $subnetId `
    --dns-service-ip $aksDnsServiceIP `
    --service-cidr $aksServiceCidr `
    --yes

- Open in portal - where is the RG

## Administering the cluster

az aks get-credentials

kubectl apply

kubectl get pods

## Routing traffic

kubectl get svc

> browse

- open in portal, find how the routing is done (PIP & LB)

## Scale

Deployment with resources - too big for node

kubectl apply 

kubectl get deploy 

k describe

Add nodepool:


  az aks nodepool add -g $rgName --cluster-name $aksClusterName `
    -n calcs `
    --node-count 1 `
    --node-vm-size $aksCalcNodeVmSize `
    --kubernetes-version $kubernetesVersion 

k get po --watch

## Lab

WHat happens if you delete and recreate the service?

> new iP address