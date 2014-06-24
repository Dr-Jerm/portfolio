
root = exports ? this

(->
    root.app = angular.module("myApp", ["ngAnimate"])
    root.app.controller "portfolioController", ($scope, $timeout, Server) ->
        $scope.loaded = false

        $scope.innerHeight = root.innerHeight

        $scope.getInnerHeightStyle = (css) ->
            style = {}
            style[css] = $scope.innerHeight+'px'
            style

        root.addEventListener 'resize', ->
            $scope.innerHeight = root.innerHeight
            $scope.$apply()
        
        Server.getPortfolioData().then ((portfolio) ->
            $scope.achievements = portfolio.achievements
            $scope.badges       = portfolio.badges
            
            #dramatic pause
            $timeout ->
                root.scrollTo 0,0
                $scope.loaded = true
            , 1000

        ), (error) ->
            console.error error

    console.log "Up and Running!"
)()