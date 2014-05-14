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
        # element.css('opacity', 1)
        # console.log element.css('opacity')

        

