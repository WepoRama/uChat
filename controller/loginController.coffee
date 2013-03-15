
uChat.controller('loginController',
    ($scope, $location, $routeParams) -> 
        $scope.approvedNick = '#nonickapproved#'
        $scope.chooseHandle = () ->
            connection.requestHandle($scope.login.handle)
            $location.path('/chatsAvailable/');
        $scope.createRoom = () ->
            connection.requestRoom($scope.login.roomName)
            $location.path('/chat/');
        $scope.sendMessage = () ->
            connection.sendMessage($scope.chat.message)
            $location.path('/chat/');
        1
);
