baseURL = 'http://localhost:7474'
restAPI = "#{baseURL}/db/data"

angular.module('neo4jApp.settings', [])
  .constant('Settings', {
    host: baseURL
    endpoint:
      rest: restAPI
      cypher: "#{restAPI}/cypher"
      transaction: "#{restAPI}/transaction"
  })
