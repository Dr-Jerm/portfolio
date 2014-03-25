root = exports ? this

root.app.directive 'blob', () ->
  restrict: 'E'
  scope: {
  	details: '='
  }
  templateUrl: 'partials/blob'
  link: (scope, element, attrs) ->
    console.log('blob ' +scope.title+' loaded!')
  
