describe 'Session', ->

  Given ->
    @CookieParser = () ->
      @fn
    @CookieParser.fn = (cookie, cb) ->
      cb(null, {})

  Given ->
    @MemoryStore = class SessionStore
      get: (id, cb) -> cb null, session

  Given ->
    @ExpressSession = class ExpressSession
    @ExpressSession.MemoryStore = @MemoryStore
    
  Given -> @SocketSessions = requireSubject 'lib/session', {
    'cookie-parser': @CookieParser
    'express-session': @ExpressSession
  }

  Given -> @store = new @MemoryStore
  Given -> @key = 'key'
  Given -> @parser = new @CookieParser
  Given -> @settings =
    store: @store
    key: @key
    parser: @parser
  Given -> @socket = {}
  Given -> @cb = ->

  describe '#', ->
    Given -> spyOn(@SocketSessions,['init']).andCallThrough()
    When -> @res = @SocketSessions()
    Then -> expect(@res.instance instanceof @SocketSessions).toBe true
    And -> expect(@SocketSessions.init).toHaveBeenCalled()

  describe '# (settings:Object={store:MemoryStore,key:String,parse:CookieParser)', ->
    Given -> spyOn(@SocketSessions,['init']).andCallThrough()
    When -> @res = @SocketSessions @settings
    Then -> expect(@res.instance instanceof @SocketSessions).toBe true
    And -> expect(@SocketSessions.init).toHaveBeenCalledWith @res.instance, @settings

  describe '#init', ->

    When -> @res = @SocketSessions.init()
    Then -> expect(@res.instance instanceof @SocketSessions).toBe true
    And -> expect(@res.instance.store instanceof @MemoryStore).toBe true
    And -> expect(typeof @res.instance.key).toBe 'string'
    And -> expect(@res.instance.key).toBe 'io'
    And -> expect(@res.instance.parser).toBe @CookieParser()


  describe '#init (instance:null,options:Object)', ->

    When -> @res = @SocketSessions.init null, @settings
    Then -> expect(@res.instance instanceof @SocketSessions).toBe true
    And -> expect(@res.instance.store instanceof @MemoryStore).toBe true
    And -> expect(@res.instance.store).toEqual @store
    And -> expect(typeof @res.instance.key).toBe 'string'
    And -> expect(@res.instance.key).toEqual @key
    And -> expect(@res.instance.parser instanceof @CookieParser).toBe true
    And -> expect(@res.instance.parser).toEqual @parser

  describe 'prototype', ->

    Given -> spyOn(@store,['get']).andCallThrough()
    Given -> @instance = @SocketSessions.init @settings

    describe '#middleware (socket:Socket, cb:Function)', ->
