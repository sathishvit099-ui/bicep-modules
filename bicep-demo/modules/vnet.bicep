param vnetName string
param location string

param addressSpace string

param webSubnet string
param appSubnet string
param dbSubnet string

param webPrefix string
param appPrefix string
param dbPrefix string

param nsgId string
param routeTableId string
param natGatewayId string

// Azure Bastion subnet
param bastionSubnetName string
param bastionSubnetPrefix string

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location

  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpace
      ]
    }

    subnets: [

      //=================================================
      // Public Subnet
      //=================================================
      {
        name: webSubnet

        properties: {
          addressPrefix: webPrefix

          networkSecurityGroup: {
            id: nsgId
          }

          routeTable: {
            id: routeTableId
          }
        }
      }

      //=================================================
      // App Subnet
      //=================================================
      {
        name: appSubnet

        properties: {
          addressPrefix: appPrefix

          networkSecurityGroup: {
            id: nsgId
          }

          routeTable: {
            id: routeTableId
          }

          natGateway: {
            id: natGatewayId
          }
        }
      }

      //=================================================
      // Database Subnet
      //=================================================
      {
        name: dbSubnet

        properties: {
          addressPrefix: dbPrefix

          networkSecurityGroup: {
            id: nsgId
          }
        }
      }

      //=================================================
      // Azure Bastion Subnet
      //=================================================
      {
        name: bastionSubnetName

        properties: {
          addressPrefix: bastionSubnetPrefix
        }
      }

    ]
  }
}

output vnetId string = vnet.id

output appSubnetId string = resourceId(
  'Microsoft.Network/virtualNetworks/subnets',
  vnet.name,
  appSubnet
)

output bastionSubnetId string = resourceId(
  'Microsoft.Network/virtualNetworks/subnets',
  vnet.name,
  bastionSubnetName
)
