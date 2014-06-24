root = exports ? this
  
## would like to go back to transcluding the inner carousel at some point

root.app.directive 'blob', () ->
    restrict: 'A'
    scope: {
        details: '='
    }
    templateUrl: 'partials/blob'
    link: (scope, element, attrs) ->
        console.log('blob ' +scope.details.title+' loaded!')
        scope.hover = false

        scope.enter = (event) ->
            console.log event
            hover = true
        scope.leave = (event) ->
            hover = false
            console.log event
