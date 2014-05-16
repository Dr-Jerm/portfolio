root = exports ? this
  
root.app.directive 'carouselle', () ->
    restrict: 'E'
    scope: {
        items: '='
    }
    templateUrl: 'partials/carouselle'
    link: (scope, element, attrs) ->

        scope.debug = ->
            debugger

        scope.$watch('items', ->
            if scope.items
                scope.itemCount = scope.items.length
        )
        scope.selected = 0
        scope.left = true
        scope.right = false

        scope.getClass = (index) ->
            if index == scope.selected
                if scope.left
                    return 'right'
                if scope.right
                    return 'left'
            if index > scope.selected
                return 'right'
            if index < scope.selected
                return 'left'

        scope.switchTo = (index) ->
            if index > scope.selected
                scope.left = true
                scope.right = false
            if index < scope.selected
                scope.right = true
                scope.left = false;
            scope.selected = index
            console.log(index);
        

