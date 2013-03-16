
uChat.service 'chatModel', () ->
    connection.setAddHistoryLine (l)->
        this.addLine(l)
    this.getNickName = () ->
        window.localStorage.getItem 'nick'
    this.getHistory = () ->
        history = JSON.parse ( window.localStorage.getItem 'history' )
        return history if history
        []
    this.addLine = (line) ->
        history = this.getHistory()
        history.push line
        window.localStorage.setItem 'history', JSON.stringify(chapter)

