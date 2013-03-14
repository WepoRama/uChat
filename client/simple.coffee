window.WebSocket = window.WebSocket 

addEventListener('message', (e) -> connection.send(e))

connection = new WebSocket('ws://127.0.0.1:1337')

connection.onopen = () ->

connection.onerror = (error) ->

connection.requestHandle = (handle) ->
    connection.send(handle)

connection.onmessage = (message) ->
    try 
        json = JSON.parse(message.data);
    catch e
        console.log('This doesn\'t look like a valid JSON: ', message.data);
    setHistory json.history if json.type == 'history'
    addLine json.line if json.type == 'message'
    acceptNick json.nick if json.type == 'acceptNickname'
    refuseNick json.nick if json.type == 'refuseNickname'
setHistory = (history) ->    
    console.log line for line in history
addLine = (line) ->    
    console.log line
acceptNick = (nick) ->    
    console.log 'accept ', nick
refuseNick = (nick) ->    
    console.log 'refuse ', nick
