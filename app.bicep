import radius as radius

@description('The tenant ID of the Azure SPN to use for deployment."')
param arm_tenant_id string 

@description('The subscription ID of the Azure SPN to use for deployment."')
param arm_subscription_id string 

@description('The application/client ID of the Azure SPN to use for deployment."')
param arm_client_id string 

@secure()
param arm_client_secret string

resource env 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'webapp-dev'
  location: 'global'
  properties: {
    compute: {
      kind: 'kubernetes'   // Required. The kind of container runtime to use
      resourceId: 'self'
      namespace: 'docker-desktop' // Required. The Kubernetes namespace in which to render application resources
      //namespace: 'default' // Required. The Kubernetes namespace in which to render application resources
      // identity: {          // Optional. External identity providers to use for connections
      //   kind: 'azure.com.workload'
      //   oidcIssuer: oidcIssuer
     // }
    }
    recipeConfig: {
      terraform: {
        providers: {
          azurerm: [{
            ARM_TENANT_ID: arm_tenant_id
            ARM_SUBSCRIPTION_ID: arm_subscription_id
            ARM_CLIENT_ID: arm_client_id
            ARM_CLIENT_SECRET: arm_client_secret
          }]
        }
      }
    }
    recipes: {
      'Applications.Core/extenders': {
        defaultazurerm: {
          templateKind: 'terraform'
          templatePath: 'git::https://github.com/rapster83/terraform-azure-radius'
        }
      }
    }
  }
}

