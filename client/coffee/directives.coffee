root = exports ? this

# root.app.directive 'blob', () ->
#     restrict: 'EA'
#     scope: {
#         details: '='
#     }
#     templateUrl: 'partials/blob'
#     link: (scope, element, attrs) ->
#         console.log('blob ' +scope.title+' loaded!')
#         scope.hover = false

#         scope.enter = (event) ->
#             console.log event
#             hover = true
#         scope.leave = (event) ->
#             hover = false
#             console.log event

# root.app.directive 'centered', () ->
#     restrict: 'E'
#     transclude: true
#     template : "<div class=\"angular-center-container\">\
#                     <div class=\"angular-centered\" ng-transclude>\
#                     </div>\
#                 </div>"
  
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
        scope.animDir = undefined

        scope.isVisible = (index) ->
            return index == scope.selected

        scope.getAnimDir = ->
            if scope.animDir == 'left'
                return {left: "-1000px"}
            if scope.animDir == 'right'
                return {left: root.innerHeight+1000+"px"}
            # return {left: '0px'}

        scope.switchTo = (index) ->
            if index > scope.selected
                scope.animDir = 'left'
            if index < scope.selected
                scope.animDir = 'right'
            scope.selected = index
            console.log(index);
        

