#window.WebSocket = window.WebSocket 

###
localHistory = [{author:'system', text:'Welcome to chat'}]
mylines = localHistory 
addEventListener('message', (e) -> connection.send(e))
###

connection = new WebSocket('ws://127.0.0.1:8088')

# Websocket client communicates with the socket server



# set callback methods for data coming in from the server

connection.setSetUsers = (u) ->
    connection.setUsers = u
connection.setAddHistoryLine = (f) ->
    connection.addHistory = f
connection.setChooseNick = (f) ->
    connection.chooseNick = f
connection.setGetRooms = (f) ->
    connection.getRooms = f

# unsused callback functions (from the below connect call)
connection.onopen = () ->
connection.onerror = (error) ->

# outgoing calls from various points to the WS Server
sendJSON = (type, data) ->
    obj =
        type: type
        data: data
    connection.send JSON.stringify obj
connection.requestHandle = (handle) ->
    sendJSON 'handle', handle
connection.requestRoomList = (roomName) ->
    sendJSON 'listRooms', ''
connection.joinRoom = (roomName) ->
    sendJSON 'join', roomName
connection.requestRoom = (roomName) ->
    sendJSON 'room', roomName
connection.sendMessage = (message) ->
    sendJSON 'message', message
connection.kick = (user,room) ->
    sendJSON 'kick',
        user: user
        room: room

# Incoming messages from the server, dispersed here to the recipients
connection.onmessage = (message) ->
    try
        json = JSON.parse(message.data)
    catch e
        console.log('This doesn\'t look like a valid JSON: ', message.data)
    setHistory json.data if json.type == 'history'
    addLine    json.data if json.type == 'message'
    acceptNick json.data if json.type == 'acceptNickname'
    refuseNick json.data if json.type == 'refuseNickname'
    roomList   json.data if json.type == 'roomList'
    viewers    json.data if json.type == 'viewers'
    urKicked   json.data if json.type == 'kick'

urKicked = (data) ->
    addLine
        time: (new Date()).getTime(),
        text: "You have been kicked from " + data.room
        author: userName
        room: data.room
viewers = (data) ->
    connection.setUsers data
setHistory = (history) ->
    #console.log line for line in history
addLine = (line) ->
    console.log line
    connection.addHistory line
setNick = (nick) ->
    window.localStorage.setItem 'nick', nick
    connection.chooseNick nick
acceptNick = (nick) ->
    console.log 'accept ', nick
    #sessionStorage.nickName = nick
    setNick nick
refuseNick = (nick) ->
    console.log 'refuse ', nick
    nonick = '('+nick+')'
    setNick nonick
roomList  = (list) ->
    console.log 'Rooms: ', list
    connection.getRooms list
