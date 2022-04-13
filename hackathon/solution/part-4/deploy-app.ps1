
# utils:
filter timestamp {"$(Get-Date -UFormat '%T') | $_"}

# default settings - can override in environment variables:
$rgName = if ($env:RG_NAME) { $env:RG_NAME } else { 'hackathon' };
$acrName = if ($env:ACR_NAME) { $env:ACR_NAME } else { 'dotnetaz001' };
$aksName = if ($env:AKS_NAME) {$env:AKS_NAME} else { 'aks01' }

$acr="$($acrName).azurecr.io"
echo "** Building images for ACR: $acr" | timestamp
docker build -t "$acr/rng/api:6.0" -f ./hackathon/project/docker/api/Dockerfile ./hackathon/project
docker build -t "$acr/rng/web:6.0" -f ./hackathon/project/docker/web/Dockerfile ./hackathon/project

echo "** Logging in to ACR: $acr" | timestamp
az acr login -n $acrName

echo "** Pushing images to ACR: $acr" | timestamp
docker push "$acr/rng/api:6.0" 
docker push "$acr/rng/web:6.0"

echo "** Connecting to AKS: $aksName" | timestamp
az aks get-credentials -g $rgName -n $aksName

echo "**Deploying to AKS: $aksName" | timestamp
kubectl apply -f ./hackathon/solution/part-4/kubernetes/

echo "**Printing Service details: $aksName" | timestamp
kubectl get service numbers-web