
uChat.controller('loginController',
    ($scope, $location, $routeParams) -> 
        $scope.chooseHandle = () ->
            $location.path('/chatsAvailable/');
        $scope.createRoom = () ->
            $location.path('/chat/');
        $scope.sendMessage = () ->
            $location.path('/chat/');
        1
);
