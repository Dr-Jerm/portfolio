root = exports ? this

root.app.directive 'blob', () ->
    restrict: 'A'
    scope: {
        details: '='
    }
    templateUrl: 'partials/blob'
    link: (scope, element, attrs) ->
        console.log('blob ' +scope.title+' loaded!')
  
root.app.directive 'dissapears', () ->
    restrict: 'A'
    scope: {}
    link: (scope, element, attrs) ->
        # element.css('opacity', 1)
        # console.log element.css('opacity')

        # scope.hover = (event) ->
        #     console.log event