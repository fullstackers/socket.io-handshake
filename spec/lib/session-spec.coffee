describe 'Session', ->

  Given ->
    @CookieParser = () ->
      (cookie, cb) ->
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
    And -> expect(@SocketSessions.init).toHaveBeenCalledWith @settings

  describe '#init', ->

    When -> @res = @SocketSessions.init()
    Then -> expect(@res instanceof @SocketSessions).toBe true
    And -> expect(@res.store instanceof @MemoryStore).toBe true
    And -> expect(typeof @res.key).toBe 'string'
    And -> expect(@res.key).toBe 'io'
    And -> expect(@res.parser).toEqual @CookieParser()


  describe '#init (instance:null,options:Object)', ->

    When -> @res = @SocketSessions.init null, @settings
    Then -> expect(@res instanceof @SocketSessions).toBe true
    And -> expect(@res.store instanceof @MemoryStore).toBe true
    And -> expect(@res.store).toEqual @store
    And -> expect(typeof @res.key).toBe 'string'
    And -> expect(@res.key).toEqual @key
    And -> expect(@res.parser instanceof @CookieParser).toBe true
    And -> expect(@res.parser).toEqual @parser

  describe 'prototype', ->

    Given -> spyOn(@store,['get']).andCallThrough()
    Given -> @instance = @SocketSessions.init @settings

    describe '#middleware (socket:Socket, cb:Function)', ->
