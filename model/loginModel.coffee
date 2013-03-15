uChat.service 'loginModel', () ->
    localStorage.nickName = 'MyFineNick'
    this.getNickName = () ->
        localStorage.nickName or '#NoNickNameRegistered#'
    this.getHistory = () ->
        localStorage.history or '...'
