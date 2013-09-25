#baseURL = 'http://localhost:7474'
baseURL = ''
restAPI = "#{baseURL}/db/data"

angular.module('neo4jApp.settings', [])
  .constant('Settings', {
    cmdchar: ':'
    endpoint:
      console: "#{baseURL}/db/manage/server/console"
      jmx: "#{baseURL}/db/manage/server/jmx/query"
      rest: restAPI
      cypher: "#{restAPI}/cypher"
      transaction: "#{restAPI}/transaction"
    host: baseURL
    maxFrames: 50
  })
