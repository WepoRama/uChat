var uChatConfig = function($routeProvider) {
    $routeProvider
        .when('/', {
            controller: 'loginController',
            templateUrl: 'view/login.html'
        })
        .when('/chatsAvailable/', {
            controller: 'roomController',
            templateUrl: 'view/chatsAvailable.html'
        })
        ;
    };
var uChat = angular.module('uChat', []).
config( uChatConfig );
