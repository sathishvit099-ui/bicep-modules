param bastionName string
param publicIpName string
param location string

param bastionSubnetId string

// Public IP for Azure Bastion
resource bastionPip 'Microsoft.Network/publicIPAddresses@2024-05-01' = {
  name: publicIpName
  location: location

  sku: {
    name: 'Standard'
  }

  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// Azure Bastion Host
resource bastion 'Microsoft.Network/bastionHosts@2024-05-01' = {
  name: bastionName
  location: location

  sku: {
    name: 'Standard'
  }

  properties: {
    ipConfigurations: [
      {
        name: 'bastion-ipconfig'

        properties: {
          subnet: {
            id: bastionSubnetId
          }

          publicIPAddress: {
            id: bastionPip.id
          }
        }
      }
    ]
  }
}

output bastionId string = bastion.id
