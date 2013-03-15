
uChat.controller('loginController',
    ($scope, $location, $routeParams) -> 
        $scope.approvedNick = localStorage.approvedNick or '#nna#'
        $scope.history = localStorage.history or '---'
        $scope.chooseHandle = () ->
            connection.requestHandle($scope.login.handle)
            $location.path('/chatsAvailable/');
        $scope.createRoom = () ->
            connection.requestRoom($scope.login.roomName)
            $location.path('/chat/');
        # TODO: move to seperate Controller
        $scope.sendMessage = () ->
            connection.sendMessage($scope.chat.message)
            $scope.history = localStorage.history 
            $location.path('/chat/');
        1
);
