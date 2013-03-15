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
        .when('/chat/', {
            controller: 'loginController',
            templateUrl: 'view/chat.html'
        })
    1
        
uChat = angular.module('uChat', []).
    config( uChatConfig );

1
