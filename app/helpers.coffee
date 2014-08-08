root = exports ? this

(->
    root.app.factory 'Server', ($q, $http) ->
        getPortfolioData = ->
            deferred = $q.defer()

            $http.get('/api/portfolio').then ((response) ->
                deferred.resolve response.data
            ), (error) -> 
                deferred.reject error

            deferred.promise

        {
            getPortfolioData: getPortfolioData
        }
)()