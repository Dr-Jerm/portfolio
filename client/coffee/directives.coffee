root = exports ? this

root.app.directive 'blob', () ->
    restrict: 'A'
    scope: {
        details: '='
    }
    templateUrl: 'partials/blob'
    link: (scope, element, attrs) ->
        console.log('blob ' +scope.title+' loaded!')
        scope.hover = false

        scope.enter = (event) ->
            console.log event
            hover = true
        scope.leave = (event) ->
            hover = false
            console.log event
  
root.app.directive 'dissapears', () ->
    restrict: 'A'
    # scope: {}
    link: (scope, element, attrs, $timeout) ->
        # element.css('opacity', 1)
        # console.log element.css('opacity')

        hover = false
        opacity = 1.0

        fade = ->
            $timeout(fadeHelper, 30);

        fadeHelper

