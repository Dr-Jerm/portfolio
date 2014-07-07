root = exports ? this
  
## would like to go back to transcluding the inner carousel at some point

root.app.directive 'blob', () ->
    restrict: 'E'
    scope: {
        details: '='
        last: '='
        pHidden: '='
    }
    replace: true
    templateUrl: 'partials/blob'
    link: (scope, element, attrs) ->
        console.log('blob ' +scope.details.title+' loaded, last: '+scope.last+' pHidden: '+scope.pHidden)
        scope.tileWidth = ->
            if root.innerWidth < 600
                return {"width": "100%"}
            if root.innerWidth < 1000
                return {"width": "50%"}
            return {"width": "33.33%"}
            
        scope.tileCount = ->
            if root.innerWidth < 600
                return 1
            if root.innerWidth < 1000
                return 2
            return 3
            
        scope.fontSize = ->
            if root.innerWidth < 1000
                return {"font-size": "90%"}
            return {"font-size": "100%"}
            
        

root.app.directive 'badge', () ->
    restrict: 'A'
    scope: {
        details: '='
    }
    templateUrl: 'partials/badge'
