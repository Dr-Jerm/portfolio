
root = exports ? this

(->
    root.app = angular.module("myApp", ["ngAnimate"])
    root.app.controller "portfolioController", ($scope, Server) ->
        $scope.loaded = false
        root.scrollTo 0,0

        $scope.innerHeight = root.innerHeight

        $scope.getInnerHeightStyle = (css) ->
            style = {}
            style[css] = $scope.innerHeight+'px'
            style

        root.addEventListener 'resize', ->
            $scope.innerHeight = root.innerHeight
            $scope.$apply()
        
        Server.getPortfolioData().then ((portfolio) ->
            $scope.works       = portfolio.works
            $scope.experiments = portfolio.experiments
            $scope.histories   = portfolio.histories

            # $scope.loaded = true
        ), (error) ->
            console.error error

    console.log "Up and Running!"
)()