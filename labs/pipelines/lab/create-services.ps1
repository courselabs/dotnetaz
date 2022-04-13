
# utils:
filter timestamp {"$(Get-Date -UFormat '%T') | $_"}

echo "** Creating RG: $env:RG_NAME" | timestamp
az group create -n $env:RG_NAME -l $env:REGION

echo "** Creating ACR: $env:ACR_NAME" | timestamp
az acr create -g $env:RG_NAME -l $env:REGION --sku $env:ACR_SKU -n $env:ACR_NAME

echo "** Creating AKS: $env:AKS_NAME" | timestamp
az aks create -n $env:AKS_NAME -g $env:RG_NAME -l $env:REGION `
  --node-count $env:AKS_NODE_COUNT `
  --node-vm-size $env:AKS_NODE_SIZE `
  --no-ssh-key --yes
  
echo 'Attaching ACR to AKS' | timestamp
$acrIaz aks update -g $env:RG_NAME -n $env:AKS_NAME `
  --attach-acr $env:ACR_NAME --yes  

# ^ this will fail because of https://github.com/Azure/AKS/issues/1517
# the Azure ID that DevOps uses doesn't have permission to do this
