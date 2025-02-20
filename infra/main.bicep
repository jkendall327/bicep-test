param appName string
param location string = resourceGroup().location
param sku string = 'F1'

resource serverFarm 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: '${appName}-asp'
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
  name: appName
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
