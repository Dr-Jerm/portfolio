root = exports ? this

root.app.directive 'youtube', ($sce) ->
    restrict: 'E'
    scope: {
        hash: '@',
    }
    templateUrl: 'partials/youtube'
    link: ($scope, element, attrs) ->
        $scope.style = {}
        
        $scope.width = 560
        $scope.height = 315
        
        if (root.innerWidth < 560) 
            debugger
            $scope.width = "100%"
            $scope.height = "100%"
        
        $scope.$watch 'hash', (newVal) ->
           if (newVal)
               $scope.url = $sce.trustAsResourceUrl("http://www.youtube.com/embed/" + newVal);
           