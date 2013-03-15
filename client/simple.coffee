window.WebSocket = window.WebSocket 

###
localHistory = [{author:'system', text:'Welcome to chat'}]
mylines = localHistory 
addEventListener('message', (e) -> connection.send(e))
###

connectin.setAddHistoryLine = (f) ->
    connection.addHistory = f
connection = new WebSocket('ws://127.0.0.1:1337')

connection.onopen = () ->

connection.onerror = (error) ->

connection.requestHandle = (handle) ->
    connection.send(handle)
connection.requestRoom = (roomName) ->
    connection.send(roomName)
connection.sendMessage = (message) ->
    connection.send(message)

connection.onmessage = (message) ->
    try 
        json = JSON.parse(message.data);
    catch e
        console.log('This doesn\'t look like a valid JSON: ', message.data);
    setHistory json.data if json.type == 'history'
    addLine    json.data if json.type == 'message'
    acceptNick json.data if json.type == 'acceptNickname'
    refuseNick json.data if json.type == 'refuseNickname'
setHistory = (history) ->    
    console.log line for line in history
addLine = (line) ->    
    console.log line
    #lines = localStorage.history
    #lines = [] if lines is undefined
    #localHistory.push line
    connection.addHistory line 
acceptNick = (nick) ->    
    console.log 'accept ', nick
    sessionStorage.nickName = nick
refuseNick = (nick) ->    
    console.log 'refuse ', nick
