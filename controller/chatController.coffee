
uChat.controller 'chatController',
    ($scope, $location, $routeParams) -> 
        $scope.history = [{author:'system', text:'Welcome'}] if $scope.history is undefined
        connection.setAddHistoryLine (l) ->
            #$scope.history.push l
        $scope.sendMessage = () ->
            connection.sendMessage($scope.chat.message)
            $scope.history = localStorage.history 
            $location.path('/chat/');
