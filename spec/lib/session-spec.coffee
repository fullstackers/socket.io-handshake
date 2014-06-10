describe 'Session', ->

  Given -> @Session = requireSubject 'lib/session', {}
  Then -> expect(@Session() instanceof @Session).toBe true
