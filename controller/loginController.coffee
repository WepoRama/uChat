
uChat.controller('loginController',
    ($scope, $location, $routeParams) -> 
        $scope.chooseHandle = () ->
            $location.path('/chatsAvailable/');
        $scope.createRoom = () ->
            $location.path('/chat/');
        $scope.sendMessage = () ->
            $route.chat.message = ''
            $location.path('/chat/');
        1
);
