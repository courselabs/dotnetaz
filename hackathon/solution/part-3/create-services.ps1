
# utils:
filter timestamp {"$(Get-Date -UFormat '%T') | $_"}

# default settings - can override in environment variables:
$rgName = if ($env:RG_NAME) { $env:RG_NAME } else { 'hackathon' };
$region = if ($env:REGION) { $env:REGION } else { 'centralus' };
$acrName = if ($env:ACR_NAME) { $env:ACR_NAME } else { 'dotnetaz001' };
$aksName = if ($env:AKS_NAME) {$env:AKS_NAME} else { 'aks01' }
$aksNodeCount = if ($env:AKS_NODE_COUNT) {$env:AKS_NODE_COUNT} else { '2' }
$aksNodeSize = if ($env:AKS_NODE_SIZE) {$env:AKS_NODE_SIZE} else { 'Standard_D2_v2' }

echo "** Creating RG: $rgName" | timestamp
az group create -n $rgName -l $region

echo "** Creating ACR: $acrName" | timestamp
az acr create -g $rgName -l $region --sku Basic -n $acrName

echo "** Creating AKS: $aksName" | timestamp
az aks create -n $aksName -g $rgName -l $region `
  --node-count $aksNodeCount `
  --node-vm-size $aksNodeSize `
  --no-ssh-key --yes
  
echo 'Attaching ACR to AKS' | timestamp
az aks update -g $rgName -n $aksName `
  --attach-acr $acrName --yes  
