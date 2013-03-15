
uChat.controller 'loginController',
    ($scope, $location, $routeParams) -> 
        $scope.history = [{author:'system', text:'Welcome'}]
        $scope.approvedNick = localStorage.approvedNick or '#nna#'
        $scope.chooseHandle = () ->
            connection.setAddHistoryLine  (l) ->
                $scope.history.push l
            connection.requestHandle($scope.login.handle)
            $location.path('/chatsAvailable/');
        $scope.createRoom = () ->
            connection.requestRoom($scope.login.roomName)
            $location.path('/chat/');
        1
