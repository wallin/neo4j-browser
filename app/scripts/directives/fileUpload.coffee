'use strict';
angular.module('neo4jApp.directives')
  .controller('fileUpload', [
    '$attrs'
    '$parse'
    '$rootScope'
    '$scope'
    '$window'
    ($attrs, $parse, $rootScope, $scope, $window) ->

      onUploadSuccess = (content)->
        if $attrs.upload
          exp = $parse($attrs.upload)
          $scope.$apply(->exp($scope, {'$content': content}))

      getFirstFileFromEvent = (evt) ->
        files = evt.originalEvent.dataTransfer.files
        return files[0]

      scopeApply = (fn)->
        return ->
          fn.apply($scope, arguments)
          $scope.$apply()

      @onDragEnter = scopeApply (evt)->
        getFirstFileFromEvent(evt)
        $scope.active = yes

      @onDragLeave = scopeApply ->
        $scope.active = no

      @onDrop = scopeApply (evt) =>
        @preventDefault(evt)
        $scope.active = no
        file = getFirstFileFromEvent(evt)
        return unless file

        if $attrs.type
          return if file.type.indexOf($attrs.type) < 0
        if $attrs.extension
          # Check if name ends with extension
          reg = new RegExp($attrs.extension + "$")
          return unless file.name.match(reg)

        $scope.status = "Uploading..."
        @readFile file

      @preventDefault = (evt) ->
        evt.stopPropagation()
        evt.preventDefault()

      @readFile = (file) ->
        reader = new $window.FileReader()
        reader.onerror = scopeApply (evt) ->
          # http://www.w3.org/TR/FileAPI/#ErrorDescriptions
          $scope.status = switch evt.target.error.code
            when 1 then "#{file.name} not found."
            when 2 then "#{file.name} has changed on disk, please re-try."
            when 3 then "Upload cancelled."
            when 4 then "Cannot read #{file.name}"
            when 5 then "File too large for browser to upload."
          $rootScope.$broadcast 'fileUpload:error', $scope.error

        reader.onloadend = scopeApply (evt) ->
          data = evt.target.result
          data = data.split(';base64,')[1]
          onUploadSuccess($window.atob(data))
          $scope.status = undefined

        reader.readAsDataURL(file)
  ])


angular.module('neo4jApp.directives')
  .directive('fileUpload', [
    '$window'
    ($window) ->
      controller: 'fileUpload'
      restrict: 'E'
      scope: '@'
      transclude: yes
      template: '<div class="file-drop-area" ng-class="{active: active}" ng-transclude>{{status}}</div>'
      link: (scope, element, attrs, ctrl) ->
        return unless $window.FileReader and $window.atob
        element.bind 'dragenter', ctrl.onDragEnter
        element.bind 'dragleave', ctrl.onDragLeave
        element.bind 'drop', ctrl.onDrop
        element.bind 'dragover', ctrl.preventDefault
        element.bind 'drop'
  ])
