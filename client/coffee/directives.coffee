root = exports ? this
  
## would like to go back to transcluding the inner carousel at some point

mod = (x, m) ->
    (x%m + m)%m

root.app.directive 'carousel', () ->
    restrict: 'E'
    scope: {
        items: '='
    }
    templateUrl: 'partials/carousel'
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

        scope.moveRight = ->
            console.log "right"
            newSelected = mod(scope.selected+1, scope.itemCount)
            scope.switchTo(newSelected)

        scope.moveLeft = -> 
            console.log "left"
            newSelected = mod(scope.selected-1, scope.itemCount)
            scope.switchTo(newSelected)

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
        

