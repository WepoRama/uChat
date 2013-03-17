window.localStorage.setItem 'history', JSON.stringify([])

uChatConfig = ($routeProvider) ->
    $routeProvider
        .when('/login/', {
            controller: 'loginController',
            templateUrl: 'view/login.html'
        })
        .when('/chatsAvailable/', {
            controller: 'loginController',
            templateUrl: 'view/chatsAvailable.html'
        })
        .when('/chat/:room', {
            controller: 'chatController',
            templateUrl: 'view/chat.html'
        })
        .when('/chat/kick/:room/:nick', {
            controller: 'kickController',
            templateUrl: 'view/chat.html'
        })
    1
        
uChat = angular.module('uChat', []).
    config( uChatConfig );

1
