
root = exports ? this

(->
    root.app = angular.module("myApp", [])
    root.app.controller "portfolioController", ($scope, Server) ->
        Server.getPortfolioData().then ((portfolio) ->
            $scope.works       = portfolio.works
            $scope.experiments = portfolio.experiments
            $scope.histories   = portfolio.histories
        ), (error) ->
            console.error error

    console.log "Up and Running!"
)()