root = exports ? this
  
## would like to go back to transcluding the inner carousel at some point

root.app.directive 'blob', () ->
    restrict: 'E'
    scope: {
        details: '='
    }
    replace: true
    templateUrl: 'partials/blob'
    link: (scope, element, attrs) ->
        console.log('blob ' +scope.details.title+' loaded!')
        scope.tileCount = ->
            if root.innerWidth < 500
                return {"width": "100%"}
            if root.innerWidth < 800
                return {"width": "50%"}
            return {"width": "33.33%"}
            
        scope.fontSize = ->
            if root.innerWidth < 800
                return {"font-size": "90%"}
            return {"font-size": "100%"}

root.app.directive 'badge', () ->
    restrict: 'A'
    scope: {
        details: '='
    }
    templateUrl: 'partials/badge'
