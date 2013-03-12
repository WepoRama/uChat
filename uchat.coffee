uChatConfig = ($routeConfig) ->
    $routeConfig
    .when('/', {
        controller: 'myController',
        templateUrl: 'view/login.html'
    })
    .when('/chat', {
        controller: 'myController',
        templateUrl: 'view/chat.html'
    })
    1
        
