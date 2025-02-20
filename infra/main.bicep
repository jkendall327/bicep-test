param appName string
param location string = resourceGroup().location
param sku string = 'F1'

var uniqueAppName = '${appName}-${uniqueString(resourceGroup().id)}'

resource serverFarm 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: '${uniqueAppName}-asp'
  location: location
  sku: {
    name: sku
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2023-01-01' = {
  name: uniqueAppName
  location: location
  properties: {
    serverFarmId: serverFarm.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
      appCommandLine: 'dotnet BicepTest.dll'
      scmDoBuildDuringDeployment: true
    }
    httpsOnly: true
  }
}

output webAppName string = webApp.name
