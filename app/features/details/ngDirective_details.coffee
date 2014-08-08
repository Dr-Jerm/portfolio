root = exports ? this
  

root.app.directive 'details', ($timeout) ->
    restrict: 'E'
    scope: {
        details: '='
        last: '='
        pHidden: '='
    }
    replace: true
    templateUrl: 'partials/details'
    link: (scope, element, attrs) ->
        console.log('details ' +scope.details.title+' loaded, last: '+scope.last+' pHidden: '+scope.pHidden)
        scope.tileWidth = ->
            if root.innerWidth < 600
                return {"width": "100%"}
            if root.innerWidth < 1000
                return {"width": "50%"}
            return {"width": "33.33%"}
            
        scope.hover = false
        scope.link = false
        
        timer = null
        
        scope.$watch('hover', ->
            if scope.hover 
                timer = $timeout( -> 
                    scope.link = true
                , 100)
            else
                scope.link = false
                if timer
                    $timeout.cancel(timer))

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
            