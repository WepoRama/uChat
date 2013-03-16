
uChat.controller 'chatController',
    ($scope, $location, $routeParams, chatModel) -> 
        $scope.nick = chatModel.getNickName()
        $scope.history = chatModel.getHistory()
        connection.setAddHistoryLine (l) ->
            $scope.$apply () -> $scope.history = chatModel.addLine l
        $scope.sendMessage = () ->
            connection.sendMessage($scope.chat.message)
            $location.path('/chat/');
