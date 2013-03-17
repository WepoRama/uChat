
uChat.controller 'loginController',
    ($scope, $location, $routeParams,chatModel) -> 
        connection.setChooseNick (l) ->
            $scope.$apply () -> $scope.nick = l
        $scope.nick = chatModel.getNickName()

        $scope.chooseHandle = () ->
            connection.requestHandle($scope.nick)
            #$location.path('/chatsAvailable/');
            $location.path('/chat/');
        $scope.createRoom = () ->
            connection.requestRoom($scope.login.roomName)
            $location.path('/chat/');
        1
