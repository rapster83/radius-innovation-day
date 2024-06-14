import radius as radius

param application string
param environment string


resource chicago_infra 'Applications.Core/extenders@2023-10-01-preview'= {
  name: 'myinoday'
  properties: {
    environment: environment
    application: application
     recipe: {
       name: 'chicago'
     }
  }
}
