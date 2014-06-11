var util = require('util');
var cookieParser = require('cookie-parser');
var expressSession = require('express-session');

module.exports = Session;

function Session (options) {

  if (!(this instanceof Session)) {
    return new Session(options);
  }

  var self = this;

  Session.init(this, options);

  var fn = function (socket, cb) {
    self.middleware(socket, cb);
  };

  fn.instance = this;

  return fn;
}

Session.init = function (instance, options) {

  if (!(instance instanceof Session)) return new Session(options);

  options = options || {};

  instance.parser = options.parser || cookieParser();
  instance.store = options.store || new expressSession.MemoryStore();
  instance.key = options.key || 'io';

  return instance;
};

Session.prototype.middleware = function (socket, cb) {

};
