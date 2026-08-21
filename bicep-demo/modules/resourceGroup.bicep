targetScope = 'subscription'

@description('Resource Group Name')
param resourceGroupName string

@description('Azure Region')
param location string

@description('Tags')
param tags object

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

output resourceGroupId string = rg.id
