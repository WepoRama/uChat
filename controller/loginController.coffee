
uChat.controller 'loginController',
    ($scope, $location, $routeParams,chatModel) -> 
        $scope.chooseHandle = () ->
            #connection.setAddHistoryLine (l) -> chatModel.addLine l
            connection.requestHandle($scope.login.handle)
            #$location.path('/chatsAvailable/');
            $location.path('/chat/');
        $scope.createRoom = () ->
            connection.requestRoom($scope.login.roomName)
            $location.path('/chat/');
        1
