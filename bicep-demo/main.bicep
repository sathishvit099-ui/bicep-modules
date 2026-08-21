targetScope = 'subscription'

param resourceGroupName string
param location string = 'centralus'
param tags object

// VNet
param vnetName string
param addressSpace string

param webSubnet string
param appSubnet string
param dbSubnet string

param webPrefix string
param appPrefix string
param dbPrefix string

// Azure Bastion
param bastionSubnetName string
param bastionSubnetPrefix string
param bastionName string
param bastionPublicIpName string

// Network
param nsgName string
param routeTableName string
param publicIpName string
param natGatewayName string

// VM
param vmName string
param adminUsername string

@secure()
param adminPassword string

//===================================================
// Resource Group
//===================================================

module rg './modules/resourceGroup.bicep' = {
  name: 'createRG'

  scope: subscription()

  params: {
    resourceGroupName: resourceGroupName
    location: location
    tags: tags
  }
}

//===================================================
// NSG
//===================================================

module nsg './modules/nsg.bicep' = {
  name: 'createNSG'

  scope: resourceGroup(resourceGroupName)

  dependsOn: [
    rg
  ]

  params: {
    nsgName: nsgName
    location: location
  }
}

//===================================================
// Route Table
//===================================================

module rt './modules/routeTable.bicep' = {
  name: 'createRouteTable'

  scope: resourceGroup(resourceGroupName)

  dependsOn: [
    rg
  ]

  params: {
    routeTableName: routeTableName
    location: location
  }
}

//===================================================
// Public IP for NAT Gateway
//===================================================

module pip './modules/publicIp.bicep' = {
  name: 'createPublicIP'

  scope: resourceGroup(resourceGroupName)

  dependsOn: [
    rg
  ]

  params: {
    publicIpName: publicIpName
    location: location
  }
}

//===================================================
// NAT Gateway
//===================================================

module nat './modules/natGateway.bicep' = {
  name: 'createNatGateway'

  scope: resourceGroup(resourceGroupName)

  dependsOn: [
    pip
  ]

  params: {
    natGatewayName: natGatewayName
    location: location
    publicIpId: pip.outputs.publicIpId
  }
}

//===================================================
// Virtual Network
//===================================================

module vnet './modules/vnet.bicep' = {
  name: 'createVNet'

  scope: resourceGroup(resourceGroupName)

  dependsOn: [
    nsg
    rt
    nat
  ]

  params: {
    vnetName: vnetName
    location: location

    addressSpace: addressSpace

    webSubnet: webSubnet
    appSubnet: appSubnet
    dbSubnet: dbSubnet

    webPrefix: webPrefix
    appPrefix: appPrefix
    dbPrefix: dbPrefix

    bastionSubnetName: bastionSubnetName
    bastionSubnetPrefix: bastionSubnetPrefix

    nsgId: nsg.outputs.nsgId
    routeTableId: rt.outputs.routeTableId
    natGatewayId: nat.outputs.natGatewayId
  }
}

//===================================================
// Ubuntu VM
//===================================================

module vm './modules/vm.bicep' = {
  name: 'createVM'

  scope: resourceGroup(resourceGroupName)

  dependsOn: [
    vnet
  ]

  params: {
    vmName: vmName
    location: location

    adminUsername: adminUsername
    adminPassword: adminPassword

    subnetId: vnet.outputs.appSubnetId
  }
}

//===================================================
// Azure Bastion
//===================================================

module bastion './modules/bastion.bicep' = {
  name: 'createBastion'

  scope: resourceGroup(resourceGroupName)

  dependsOn: [
    vnet
  ]

  params: {
    bastionName: bastionName
    publicIpName: bastionPublicIpName
    location: location

    bastionSubnetId: vnet.outputs.bastionSubnetId
  }
}
