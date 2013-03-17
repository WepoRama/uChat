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
history = [ ];

# list of currently connected clients (users)
clients = [ ];

userNames = { };
userNames['nono'] = true
 
###
 * Helper function for escaping input strings
###
htmlEntities = (str) ->
    return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;')
                      .replace(/>/g, '&gt;').replace(/"/g, '&quot;')
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

    # we need to know client index to remove them on 'close' event
    index = clients.push(connection) - 1;
    userName = false;
 
    console.log((new Date()) + ' Connection accepted.');
 
    # eventually send room names here, rather than history
    # send back chat history
    #if history.length > 0 connection.sendUTF(JSON.stringify( { type: 'history', data: history} ))
 
    # message from user 
    connection.on 'message', (messageObj) ->
        if messageObj.type isnt 'utf8'
            console.log 'Rejecting funny stuff'
            return # no funny stuff
        message = JSON.parse messageObj.utf8Data
        console.log((new Date()) + ' Received Message type: ' + message.type + ' data: ' + message.data);
        if userName is false
            # remember user name
            userName = doUserName connection, message.data
            console.log (new Date()) + ' Recognize user: ' + userName 
            return 
        # log and broadcast the message
        chat = message.data
        console.log((new Date()) + ' Received Message from ' + userName + ': ' + chat);
        
        # we want to keep history of all sent messages
        obj = {
            time: (new Date()).getTime(),
            text: htmlEntities(chat),
            author: userName
        };
        history.push(obj);
        history = history.slice(-100);

        # broadcast message to all connected clients (choose correct room in time)
        json = JSON.stringify({ type:'message', data: obj });
        client.sendUTF json for client in clients;
    # user disconnected
    connection.on 'close', (connection) ->
        if userName is false 
            return
        console.log((new Date()) + " Peer " + connection.remoteAddress + " disconnected.");
        # remove user from the list of connected clients
        clients.splice(index, 1)
