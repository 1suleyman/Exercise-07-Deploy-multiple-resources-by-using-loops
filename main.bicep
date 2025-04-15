@description('The Azure regions into which the resources should be deployed.')
param locations array = [
  'westus'
  'eastus2'
  'eastasia'
]

@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param sqlServerAdministratorLoginPassword string

module databases 'modules/database.bicep' = [for location in locations: { // for each location in the locations array
  name: 'database-${location}'
  params: {
    location: location
    sqlServerAdministratorLogin: sqlServerAdministratorLogin
    sqlServerAdministratorLoginPassword: sqlServerAdministratorLoginPassword
  }
}]
