
describe 'portfolioController', ->
    scope = undefined

    beforeEach angular.mock.module 'myApp'

    beforeEach angular.mock.inject ($rootScope, $controller) ->
        scope = $rootScope.$new();

        $controller 'portfolioController', {$scope: scope}

    it 'should exist', ->
        expect(scope).toBeDefined()

    it 'should have scope variables defined', ->
        expect(scope.test).toBe('scope Variable')