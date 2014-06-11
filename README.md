**session middleware for socket.io**

```javascript
var socketSessions = require('socket.io-sessions');
var io = require('socket.io')(3000);
io.use( socketSessions() );

```

Using [connect-redis](https://www.npmjs.org/package/connect-redis "connect-redis") for our session store.

```javascript

var session = require('express-session');
var RedisStore = require('connect-redis')(session);
var sessionStore = return new RedisStore();
var cookieParser = require('cookie-parser');
var socketSessions = require('socket.io-sessions');

var io = require('socket.io')(3000);
io.use(socketSessions({store: sessionStore, key:'sid', secret:'secret', parser:cookieParser()}));

```

# Installation and Environment Setup

Install node.js (See download and install instructions here: http://nodejs.org/).

Clone this repository

    > git clone git@github.com:eiriklv/socket.io-sessions.git

cd into the directory and install the dependencies

    > cd socket.io-sessions
    > npm install && npm shrinkwrap --dev

# Running Tests

Install coffee-script

    > npm install coffee-script -g

Tests are run using grunt.  You must first globally install the grunt-cli with npm.

    > sudo npm install -g grunt-cli

## Unit Tests

To run the tests, just run grunt

    > grunt spec

## TODO
