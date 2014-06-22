describe 'Session', ->

  Given -> @id = 'NEhNorpe2dj99zAAAW'

  Given ->
    @fn = (req, res, next) =>
      req.cookies =
        io: @id
      next null
    @fn.signedCookie = => @id
    @CookieParser = () => @fn

  Given ->
    @MemoryStore = class SessionStore
      get: (id, cb) -> cb null, {}

  Given ->
    @Session = class Session

  Given ->
    @ExpressSession = class ExpressSession
    @ExpressSession.Session = @Session
    @ExpressSession.MemoryStore = @MemoryStore
    
  Given -> @SocketSessions = requireSubject 'lib/session', {
    'cookie-parser': @CookieParser
    'express-session': @ExpressSession
  }

  Given -> @store = new @MemoryStore
  Given -> @key = 'key'
  Given -> @parser = @CookieParser()
  Given -> @settings =
    store: @store
    key: @key
    parser: @parser
  Given -> @socket =
    handshake:
      headers:
        cookie: 'io=' + @id
  Given -> @cb = jasmine.createSpy 'cb'

  describe '#', ->
    Given -> spyOn(@SocketSessions,['init']).andCallThrough()
    When -> @res = @SocketSessions()
    Then -> expect(@res instanceof @SocketSessions).toBe true
    And -> expect(@SocketSessions.init).toHaveBeenCalled()

  describe '# (settings:Object={store:MemoryStore,key:String,parse:CookieParser)', ->
    Given -> spyOn(@SocketSessions,['init']).andCallThrough()
    When -> @res = @SocketSessions @settings
    Then -> expect(@res instanceof @SocketSessions).toBe true
    And -> expect(@SocketSessions.init).toHaveBeenCalledWith @res, @settings

  describe '#init', ->

    When -> @res = @SocketSessions.init()
    Then -> expect(@res instanceof @SocketSessions).toBe true
    And -> expect(@res.store instanceof @MemoryStore).toBe true
    And -> expect(typeof @res.key).toBe 'string'
    And -> expect(@res.key).toBe 'io'
    And -> expect(@res.parser).toBe @CookieParser()

  describe '#init (session:null,options:Object)', ->

    When -> @res = @SocketSessions.init null, @settings
    Then -> expect(@res instanceof @SocketSessions).toBe true
    And -> expect(@res.store instanceof @MemoryStore).toBe true
    And -> expect(@res.store).toEqual @store
    And -> expect(typeof @res.key).toBe 'string'
    And -> expect(@res.key).toEqual @key
    And -> expect(@res.parser).toEqual @parser

  describe 'prototype', ->

    Given -> spyOn(@store,['get']).andCallThrough()
    Given -> @instance = @SocketSessions.init @settings

    describe '#', ->
      
      Given -> spyOn(@instance,['middleware'])
      When -> @instance @socket, @cb
      Then -> expect(@instance.middleware).toHaveBeenCalledWith @socket, @cb

    describe '#middleware (socket:Socket, cb:Function)', ->
      When -> @instance.middleware @socket, @cb
      Then -> expect(@cb).toHaveBeenCalled()
      #And -> expect(@store.get).toHaveBeenCalledWith @id, jasmine.anyFunction()
      #And -> expect(@session.handshake.sessionID).toEqual 'NEhNorpe2dj99zAAAW'
      #And -> expect(@session.handshake.sessionStore).toEqual @instance.session.store
      #And -> expect(@session.handshake.session instanceof @Session).toBe true
