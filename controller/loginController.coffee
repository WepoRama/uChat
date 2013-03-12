uChat.controller('loginController',
    function ($scope, $location, $routeParams, NoteModel) {
    var chapterId = $routeParams.chapterId;
    $scope.cancel = function() {
        $location.path('/chapter/' + chapterId);
    }
    $scope.createNote = function() {
        NoteModel.addNote(chapterId, $scope.note.content);
        $location.path('/chapter/' + chapterId);
    }
    }
);
