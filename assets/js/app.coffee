
root = exports ? this

(->
  root.app = angular.module("myApp", [])
  root.app.controller "portfolioController", ($scope) ->
  	$scope.works = [
  		{
  			title: "Sony Gaikai"
  		}
  	]


  console.log "Up and Running!"
)()