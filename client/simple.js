// Generated by CoffeeScript 1.6.1
/*
localHistory = [{author:'system', text:'Welcome to chat'}]
mylines = localHistory 
addEventListener('message', (e) -> connection.send(e))
*/

var acceptNick, addLine, connection, refuseNick, setHistory, setNick;

connection = new WebSocket('ws://127.0.0.1:8088');

connection.setAddHistoryLine = function(f) {
  return connection.addHistory = f;
};

connection.setChooseNick = function(f) {
  return connection.chooseNick = f;
};

connection.onopen = function() {};

connection.onerror = function(error) {};

connection.requestHandle = function(handle) {
  return connection.send(handle);
};

connection.requestRoom = function(roomName) {
  return connection.send(roomName);
};

connection.sendMessage = function(message) {
  return connection.send(message);
};

connection.onmessage = function(message) {
  var e, json;
  try {
    json = JSON.parse(message.data);
  } catch (_error) {
    e = _error;
    console.log('This doesn\'t look like a valid JSON: ', message.data);
  }
  if (json.type === 'history') {
    setHistory(json.data);
  }
  if (json.type === 'message') {
    addLine(json.data);
  }
  if (json.type === 'acceptNickname') {
    acceptNick(json.data);
  }
  if (json.type === 'refuseNickname') {
    return refuseNick(json.data);
  }
};

setHistory = function(history) {};

addLine = function(line) {
  console.log(line);
  return connection.addHistory(line);
};

setNick = function(nick) {
  window.localStorage.setItem('nick', nick);
  return connection.chooseNick(nick);
};

acceptNick = function(nick) {
  console.log('accept ', nick);
  return setNick(nick);
};

refuseNick = function(nick) {
  var nonick;
  console.log('refuse ', nick);
  nonick = '(' + nick + ')';
  return setNick(nonick);
};
