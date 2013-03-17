
uChat.controller 'chatController',
    ($scope, $location, $routeParams, chatModel) -> 
        room = $routeParams.room
        $scope.nick = chatModel.getNickName()
        $scope.history = chatModel.getHistory()
        $scope.userAction = 'kick' 
        $scope.room = room
        connection.joinRoom room
        connection.setAddHistoryLine (l) ->
            $scope.$apply () -> $scope.history = chatModel.addLine l
        connection.setSetUsers (u) ->
            $scope.$apply () -> $scope.users = u
        $scope.sendMessage = () ->
            connection.sendMessage($scope.chat.message)
            $scope.chat.message = ''
            $location.path('/chat/'+room);
uChat.controller 'kickController',
    ($scope, $location, $routeParams, chatModel) -> 
        room = $routeParams.room
        nick = $routeParams.nick
        connection.kick nick,room
        $location.path('/chat/'+room);
