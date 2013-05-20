#never mind me
window.myController = ($scope) ->
    $scope.title = "MyTitle"
    $scope.todo = [
        {job: "Stuffing"
        done: false
        },
        {job: "more"
        done: true
        },{job: "Learn Angular"
        done: false
        }
    ]
    $scope.two = () ->
        [{job: "more"
        done: true
        },{job: "Learn Angular"
        done: false
        }]
