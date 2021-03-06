// Generated by CoffeeScript 1.6.1

uChat.controller('loginController', function($scope, $location, $routeParams, chatModel) {
  connection.setChooseNick(function(l) {
    return $scope.$apply(function() {
      return $scope.nick = l;
    });
  });
  connection.setGetRooms(function(r) {
    return $scope.$apply(function() {
      return $scope.rooms = r;
    });
  });
  $scope.nick = chatModel.getNickName();
  connection.requestRoomList();
  $scope.chooseHandle = function() {
    connection.requestHandle($scope.nick);
    return $location.path('/chatsAvailable/');
  };
  $scope.createRoom = function() {
    connection.requestRoom($scope.login.roomName);
    connection.requestRoomList();
    return $location.path('/chatsAvailable/');
  };
  return 1;
});
