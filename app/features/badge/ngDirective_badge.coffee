root = exports ? this

root.app.directive 'badge', () ->
    restrict: 'A'
    scope: {
        details: '='
    }
    templateUrl: 'partials/badge'
