var uChatConfig = function($routeProvider) {
    $routeProvider
        .when('/', {
            controller: 'loginController',
            templateUrl: 'view/login.html'
        }) ;
    };
var uChat = angular.module('uChat', []).
config( uChatConfig );
