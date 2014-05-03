
root = exports ? this

(->
    root.app = angular.module("myApp", ["ngAnimate"])
    root.app.controller "portfolioController", ($scope, Server) ->
        
        Server.getPortfolioData().then ((portfolio) ->
            $scope.works       = portfolio.works
            $scope.experiments = portfolio.experiments
            $scope.histories   = portfolio.histories
        ), (error) ->
            console.error error

    root.addEventListener 'touchmove', (event) ->
        if event.touches.length == 2
            event.stopPropagation()
            event.preventDefault()


    console.log "Up and Running!"
)()