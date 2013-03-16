
uChat.service 'chatModel', () ->
    connection.setAddHistoryLine (l)->
        this.addLine(l)
    this.getNickName = () ->
        window.localStorage.getItem 'nick'
    this.getHistory = () ->
        saved =  window.localStorage.getItem 'history' or JSON.stringify([])
        saved =  JSON.stringify([]) if saved.length == 0
        history = JSON.parse saved
        return history if history
        []
    this.addLine = (line) ->
        history = this.getHistory()
        history.unshift line
        window.localStorage.setItem 'history', JSON.stringify(history)
        history

