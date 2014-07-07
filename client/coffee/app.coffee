
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
        
        $scope.paddingVisible = ->
            debugger

        root.addEventListener 'resize', ->
            $scope.innerHeight = root.innerHeight
            $scope.innerWidth = root.innerWidth
            $scope.$apply()
        
        Server.getPortfolioData().then ((portfolio) ->
            $scope.achievements = portfolio.achievements
            $scope.achievementsEven = portfolio.achievements.length%2 == 0
            $scope.badges       = portfolio.badges
            
            #dramatic pause
            $timeout ->
                root.scrollTo 0,0
                $scope.loaded = true
            , 3000

        ), (error) ->
            console.error error

    console.log "Up and Running!"
)()