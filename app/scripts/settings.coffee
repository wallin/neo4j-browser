baseURL = 'http://localhost:7474'
#baseURL = ''
restAPI = "#{baseURL}/db/data"

angular.module('neo4jApp.settings', [])
  .constant('Settings', {
    host: baseURL
    endpoint:
      jmx: "#{baseURL}/db/manage/server/jmx/query"
      rest: restAPI
      cypher: "#{restAPI}/cypher"
      transaction: "#{restAPI}/transaction"
  })
