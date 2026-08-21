param routeTableName string
param location string

resource rt 'Microsoft.Network/routeTables@2024-05-01' = {
  name: routeTableName
  location: location

  properties: {
    disableBgpRoutePropagation: false

    routes: [
      {
        name: 'DefaultInternet'

        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'Internet'
        }
      }
    ]
  }
}

output routeTableId string = rt.id
