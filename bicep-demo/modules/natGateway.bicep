param natGatewayName string
param location string
param publicIpId string
resource nat 'Microsoft.Network/natGateways@2024-05-01'={
 name:natGatewayName
 location:location
 sku:{name:'Standard'}
 properties:{
  publicIpAddresses:[
   {id:publicIpId}
  ]
 }
}
output natGatewayId string=nat.id
