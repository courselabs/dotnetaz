

## Ingress

- deploy locally with nginx
- add to hosts
- browse

## Deploy AKS with AGIC

- create appgw




  echo "Creating App Gateway $appgwName" | timestamp
   
  az network public-ip create -n $appgwPipName -g $rgName `
    --allocation-method Static --sku Standard `
    --dns-name $appgwPipDnsName `
    --zone 1 2 3
  
  az network application-gateway create -n $appgwName -l $location -g $rgName `
    --sku $appgwSku  --public-ip-address $appgwPipName

az aks enable-addons -n $aksClusterName -g $rgName -a ingress-appgw --appgw-id $appgwId  

- deploy app
- find IP
- browse to azure DNS

## Use Private Images


az aks update -g $rgName -n $aksClusterName `
        --attach-acr $acrId `
        --yes

- update YAML to include ACR name
- no need to auth

## Lab

run image from aks locally in DD

imagepullsecret