uChat.controller('loginController',
    function ($scope, $location, $routeParams) {
        $scope.chooseHandle = function() {
            $location.path('/chatsAvailable/');
        }
        $scope.createRoom = function() {
            $location.path('/chat/');
        }
    }
);
