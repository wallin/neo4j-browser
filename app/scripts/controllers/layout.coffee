'use strict'
#
# Handles UI state and current page
#
angular.module('neo4jApp.controllers')
  .controller 'LayoutCtrl', [
    '$rootScope'
    '$dialog'
    '$route'
    'GraphStyle'
    'Utils'
    ($scope, $dialog, $route, GraphStyle, Utils) ->
      currentView = null

      dialog = null
      dialogOptions =
        backdrop: yes
        backdropClick: yes
        backdropFade: yes
        dialogFade: yes
        keyboard: yes

      $scope.resultDetails = ->
        if currentView?.response
          stats = currentView.response.stats
          "
            Constraints added: #{stats.constraints_added}<br>
            Constraints removed: #{stats.constraints_removed}<br>
            Indexes added: #{stats.indexes_added}<br>
            Indexes removed: #{stats.indexes_removed}<br>
            Labels added: #{stats.labels_added}<br>
            Labels removed: #{stats.labels_removed}<br>
            Nodes created: #{stats.nodes_created}<br>
            Nodes deleted: #{stats.nodes_deleted}<br>
            Properties set: #{stats.properties_set}<br>
            Relationship deleted: #{stats.relationship_deleted}<br>
            Relationships created: #{stats.relationships_created}<br>
            "

      $scope.editorHeight = 0
      $scope.editorOneLine = true
      $scope.editorChanged = (codeMirror) ->
        currentHeight = $('.view-editor').height()
        if currentHeight != $scope.editorHeight
          $scope.editorHeight = $('.view-editor').height()
          $scope.editorOneLine = codeMirror.display.showingTo == 1
          $scope.$apply() if !$scope.$$phase

      $scope.isEditorHidden = false
      $scope.toggleEditor = ->
        $scope.isEditorHidden ^= true

      $scope.isGraphExpanded = false
      $scope.toggleGraph = ->
        $scope.isGraphExpanded ^= true

      $scope.isTableExpanded = false
      $scope.toggleTable = ->
        $scope.isTableExpanded ^= true

      $scope.isSidebarShown = false
      $scope.toggleSidebar = ->
        $scope.isSidebarShown ^= true

      $scope.isInspectorShown = no
      $scope.toggleInspector = ->
        $scope.isInspectorShown ^= true

      $scope.$watch 'selectedGraphItem', Utils.debounce((val) ->
        $scope.isInspectorShown = !!val
      ,200)
      $scope.isPopupShown = false
      $scope.togglePopup = (content) ->
        if content?
          if not dialog?.isOpen()
            dialogOptions.templateUrl = 'popup-' + content
            dialog = $dialog.dialog(dialogOptions)
            dialog.open().then(->
              $scope.popupContent = null
              $scope.isPopupShown = no
            )
        else
          dialog.close() if dialog?

        # Add unique classes so that we can style popups individually
        dialog.modalEl.removeClass('modal-' + $scope.popupContent) if $scope.popupContent
        dialog.modalEl.addClass('modal-' + content) if content

        $scope.popupContent = content
        $scope.isPopupShown = !!content

      $scope.globalKey = (e) ->
        # Don't toggle anything when shortcut popup is open
        return if $scope.isPopupShown and e.keyCode != 191

        if (e.metaKey or e.ctrlKey) and e.keyCode is 13 # Cmd-Enter
          $scope.$broadcast 'views:exec'
          $scope.editorChanged()
        else if e.ctrlKey and e.keyCode is 38 # Ctrl-Up
          e.preventDefault()
          $scope.$broadcast 'views:previous'
        else if e.ctrlKey and e.keyCode is 40 # Ctrl-Down
          e.preventDefault()
          $scope.$broadcast 'views:next'
        else if e.keyCode is 27 # Esc
          if $scope.isPopupShown
            $scope.togglePopup()
          else
            $scope.toggleEditor()

        else if $scope.isEditorHidden
          e.preventDefault()
          # Toggle inspector on space
          if e.keyCode is 32 and $scope.selectedGraphItem
            $scope.toggleInspector()
          if e.keyCode is 72 # h
            $scope.toggleSidebar()
          else if e.keyCode is 84 # t
            $scope.toggleGraph()
          else if e.keyCode is 191 # ?
            $scope.togglePopup('keys')

      # First level page routes
      $scope.$on '$routeChangeSuccess', ->
        $scope.togglePopup()
        $scope.isInspectorShown = no
        $scope.currentPage = $route.current.page

  ]
