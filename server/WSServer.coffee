# http://ejohn.org/blog/ecmascript-5-strict-mode-json-and-more/
"use strict"
 
# Port where we'll run the websocket server
webSocketsServerPort = 8088
 
# websocket and http servers:
webSocketServer = require('websocket').server
http = require('http')
 
###
 * Global variables
###

# latest 100 messages; rooms to be added later:
# history = [ ];

# list of currently connected clients (users)
clients = [ ]

userNames = { }
userNames['nono'] = true

rooms = [
        {
            name: 'lounge'
            owner: 'system'
        }, {
            name: 'entrance'
            owner: 'system'
        }
    ]
     
 
###
#  Helper function for escaping input strings
###
htmlEntities = (str) ->
    return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;')
                      .replace(/>/g, '&gt;').replace(/"/g, '&quot;')


# Add a room from the user
createRoom = (connection, name, userName) ->
    rooms.push
        name: name
        owner: userName
    # Then send the list to all connections
    listRooms connection
# send room list out
listRooms = (connection) ->
    connection.sendUTF(JSON.stringify({ type:'roomList', data: rooms }))
# user wants to join this room, the client should be at index
joinRoom  = (userName, room, index) ->
    console.log ((userName or 'listener') + ' should join ' + room + ', index: ' + index )
    clnt = clients[index]
    return unless clnt
    # now we have a client
    clnt.room = room
    clnt.userName = userName
    # tell everyone in the room about the new occupant
    broadcastRoomAudience room
# see above
broadcastRoomAudience = (room) ->
    clientell = []
    for client in clients
        clientell.push client.userName if client.room == room
    json = JSON.stringify
        type:'viewers'
        data: clientell
    broadcastInfo json, room
    return room
# check username existance; refuse or create the new user
doUserName = (connection, message) ->
    userName = htmlEntities message
    console.log((new Date()) + ' Checking: ' + userName)
    if userNames[userName]
        connection.sendUTF(JSON.stringify({ type:'refuseNickname', data: userName }))
        console.log((new Date()) + ' User refused (existing): ' + userName)
        return false
    userNames[userName] = true
    connection.sendUTF(JSON.stringify({ type:'acceptNickname', data: userName }))
    console.log((new Date()) + ' User is known as: ' + userName)
    return userName
# kick 
kick = (userName, data) ->
    # no kicking room creator
    room = for r in rooms
        do (r) ->
            return r if r.name == data.room
    return if room.user != userName
    # inform one and all about kicked user.
    for client in clients
        do (client) ->
            if client.room == data.room
                client.room = ''
                client.connection.sendUTF JSON.stringify
                    owner: userName
                    type: 'kick'
                    room: data.room
    broadcastRoomAudience room
            

broadcastInfo = (json, inRoom) ->
    for client in clients
        do (client,inRoom) ->
            client.connection.sendUTF json if client.room == inRoom
 
###
 * HTTP server
###
server = http.createServer (request, response) ->
    # empty, we only do web sockets
server.listen webSocketsServerPort, () ->
    console.log((new Date()) + " Server is listening on port " + webSocketsServerPort)

###
 * WebSocket server
###
wsServer = new webSocketServer({
    # WebSocket server is tied to a HTTP server. WebSocket request is just
    # an enhanced HTTP request. For more info http://tools.ietf.org/html/rfc6455#page-6
    httpServer: server
})
 
# This callback function is called every time someone
# tries to connect to the WebSocket server
wsServer.on 'request', (request) ->
    console.log((new Date()) + ' Connection from origin ' + request.origin + '.')
 
    ###
    # accept connection - you should check 'request.origin' to make sure that
    # client is connecting from your website
    # (http://en.wikipedia.org/wiki/Same_origin_policy)
    ###
    connection = request.accept(null, request.origin)

    con =
        connection: connection
        room: ''
        userName: false
    # we need to know client index to remove them on 'close' event
    index = clients.push( con ) - 1
    userName = false
    inRoom = false
 
    console.log((new Date()) + ' Connection accepted.')
 
    # eventually send room names here, rather than history
    # send back chat history
    #if history.length > 0 connection.sendUTF(JSON.stringify( { type: 'history', data: history} ))
 
    # message from user 
    connection.on 'message', (messageObj) ->
        # check proper encoding of incoming message
        if messageObj.type isnt 'utf8'
            console.log 'Rejecting funny stuff'
            return # no funny stuff
        # See if it parses as JSON
        try
            message = JSON.parse messageObj.utf8Data
        catch e
            console.log('This doesn\'t look like a valid JSON: ',messageObj.utf8Data )
            # really should return or somesuch
        console.log((new Date()) + ' Received Message type: ' + message.type +
            ' data: ' + message.data)

        if message.type == 'listRooms'
            listRooms connection
            return
        if message.type == 'kick'
            kick userName, message.data
            return
        if message.type == 'join'
            inRoom = joinRoom userName, message.data, index
            return
        if message.type == 'room'
            createRoom connection, message.data, userName
            return
        if message.type == 'handle'
            # remember user name
            userName = doUserName connection, message.data
            console.log (new Date()) + ' Recognize user: ' + userName
            return
        # log and broadcast the message
        chat = message.data
        console.log((new Date()) + ' Received Message from ' + userName + ': ' + chat
        
        obj = {
            time: (new Date()).getTime(),
            text: htmlEntities(chat),
            author: userName
            room: inRoom
        }

        if not userName
            obj.text = "Please choose a valid nick to be able to chat"
            obj.author = '(system says)'
            connection.sendUTF JSON.stringify({ type:'message', data: obj })
            return

        # we want to keep history of all sent messages
        # history.push(obj)
        # history = history.slice(-100)

        # broadcast message to all connected clients, choose correct room
        json = JSON.stringify({ type:'message', data: obj })
        broadcastInfo json, inRoom

        return
    # user disconnected
    connection.on 'close', (connection) ->
        if userName is false 
            return
        console.log((new Date()) + " Peer " + connection.remoteAddress + " disconnected.")
        # remove user from the list of connected clients
        clients.splice(index, 1)
        return
