
root = exports ? this

(->
    root.app = angular.module("myApp", ["ngAnimate"])
    root.app.controller "portfolioController", ($scope, $timeout) ->
        $scope.loaded = false

        $scope.innerHeight = root.innerHeight

        $scope.getInnerHeightStyle = (css) ->
            style = {}
            style[css] = $scope.innerHeight+'px'
            style

        root.addEventListener 'resize', ->
            $scope.innerHeight = root.innerHeight
            $scope.innerWidth = root.innerWidth
            $scope.$apply()
            
        $timeout ->
            root.scrollTo 0,0
            $scope.loaded = true
        , 3000

    console.log "Up and Running!"
)()