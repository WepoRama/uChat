
uChat.controller 'loginController',
    ($scope, $location, $routeParams,chatModel) ->
        connection.setChooseNick (l) ->
            $scope.$apply () -> $scope.nick = l
        connection.setGetRooms (r) ->
            $scope.$apply () -> $scope.rooms = r
        $scope.nick = chatModel.getNickName()

        connection.requestRoomList()

        $scope.chooseHandle = () ->
            connection.requestHandle($scope.nick)
            $location.path('/chatsAvailable/')
            #$location.path('/chat/');
        $scope.createRoom = () ->
            connection.requestRoom($scope.login.roomName)
            connection.requestRoomList()
            $location.path('/chatsAvailable/')
        1
