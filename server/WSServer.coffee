# http://ejohn.org/blog/ecmascript-5-strict-mode-json-and-more/
"use strict";
 
# Port where we'll run the websocket server
webSocketsServerPort = 8088;
 
# websocket and http servers:
webSocketServer = require('websocket').server;
http = require('http');
 
###
 * Global variables
###

# latest 100 messages; rooms to be added later:
# history = [ ];

# list of currently connected clients (users)
clients = [ ];

userNames = { };
userNames['nono'] = true

rooms = [
     'lounge'
     'entrance'
     ]
     
 
###
 * Helper function for escaping input strings
###
htmlEntities = (str) ->
    return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;')
                      .replace(/>/g, '&gt;').replace(/"/g, '&quot;')
createRoom = (connection, name) ->
    rooms.push name
    listRooms connection
listRooms = (connection) ->
    connection.sendUTF(JSON.stringify({ type:'roomList', data: rooms }));
joinRoom  = (userName, room, index) ->
    console.log userName or 'listener' + ' should join ' + room
    clnt = clients[index]
    clnt.inRoom = room
    return room
doUserName = (connection, message) ->
    userName = htmlEntities message
    console.log((new Date()) + ' Checking: ' + userName);
    if userNames[userName]
        connection.sendUTF(JSON.stringify({ type:'refuseNickname', data: userName }));
        console.log((new Date()) + ' User refused (existing): ' + userName);
        return false
    userNames[userName] = true
    connection.sendUTF(JSON.stringify({ type:'acceptNickname', data: userName }));
    console.log((new Date()) + ' User is known as: ' + userName);
    return userName
 
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
    console.log((new Date()) + ' Connection from origin ' + request.origin + '.');
 
    ###
    # accept connection - you should check 'request.origin' to make sure that
    # client is connecting from your website
    # (http://en.wikipedia.org/wiki/Same_origin_policy)
    ###
    connection = request.accept(null, request.origin); 

    con =
        connection: connection
        room: ''
    # we need to know client index to remove them on 'close' event
    index = clients.push( con ) - 1;
    userName = false;
    inRoom = false;
 
    console.log((new Date()) + ' Connection accepted.');
 
    # eventually send room names here, rather than history
    # send back chat history
    #if history.length > 0 connection.sendUTF(JSON.stringify( { type: 'history', data: history} ))
 
    # message from user 
    connection.on 'message', (messageObj) ->
        if messageObj.type isnt 'utf8'
            console.log 'Rejecting funny stuff'
            return # no funny stuff
        try
            message = JSON.parse messageObj.utf8Data
        catch e
            console.log('This doesn\'t look like a valid JSON: ',messageObj.utf8Data );
        console.log((new Date()) + ' Received Message type: ' + message.type + ' data: ' + message.data);

        if message.type == 'listRooms'
            listRooms connection
            return
        if message.type == 'join'
            inRoom = joinRoom userName, message.data, index
            return
        if message.type == 'room'
            createRoom connection, message.data
            return
        if message.type == 'handle'
            # remember user name
            userName = doUserName connection, message.data
            console.log (new Date()) + ' Recognize user: ' + userName 
            return 
        # log and broadcast the message
        chat = message.data
        console.log((new Date()) + ' Received Message from ' + userName + ': ' + chat);
        
        obj = {
            time: (new Date()).getTime(),
            text: htmlEntities(chat),
            author: userName
            room: inRoom
        };

        if not userName
            obj.text = "Please choose a valid nick to be able to chat"
            obj.author = '(system says)'
            connection.sendUTF JSON.stringify({ type:'message', data: obj });
            return

        # we want to keep history of all sent messages
        # history.push(obj);
        # history = history.slice(-100);

        # broadcast message to all connected clients, choose correct room
        json = JSON.stringify({ type:'message', data: obj });
        for client in clients
            do (client,inRoom) ->
                console.log (new Date()) + " Im in room '" + inRoom + "' client is in: " + client.inRoom
                console.log ("Sending" + obj.text)
                client.connection.sendUTF json if client.inRoom == inRoom
        return
    # user disconnected
    connection.on 'close', (connection) ->
        if userName is false 
            return
        console.log((new Date()) + " Peer " + connection.remoteAddress + " disconnected.");
        # remove user from the list of connected clients
        clients.splice(index, 1)
        return
