
uChat.controller 'chatController',
    ($scope, $location, $routeParams) -> 
        $scope.history = localStorage.history or [{author:'system', text:'---'}]
        connection.setAddHistoryLine (l) ->
            $scope.history.push l
        $scope.sendMessage = () ->
            connection.sendMessage($scope.chat.message)
            $scope.history = localStorage.history 
            $location.path('/chat/');
