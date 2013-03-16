// Generated by CoffeeScript 1.6.1

uChat.controller('chatController', function($scope, $location, $routeParams, chatModel) {
  $scope.nick = chatModel.getNickName();
  $scope.history = chatModel.getHistory();
  connection.setAddHistoryLine(function(l) {
    return $scope.history = chatModel.addLine(l);
  });
  return $scope.sendMessage = function() {
    connection.sendMessage($scope.chat.message);
    return $location.path('/chat/');
  };
});
