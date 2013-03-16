
uChat.controller 'chatController',
    ($scope, $location, $routeParams, chatModel) -> 
        connection.setAddHistoryLine (l) ->
            chatModel.addLine l
        $scope.sendMessage = () ->
            connection.sendMessage($scope.chat.message)
            $location.path('/chat/');
