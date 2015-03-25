_ = require 'lodash'
Promise = require 'bluebird'
express = require 'express'
log = require 'loglevel'

class Router
  constructor: ->
    @router = express.Router({caseSensitive: true})

    # coffeelint: disable=missing_fat_arrows
    @Handled = -> null
    @Handled.prototype = new Error()

    @Error400 = (message) ->
      @name = 'Error400'
      @message = message
      @stack = (new Error()).stack
    @Error400.prototype = new Error()

    @Error401 = (message) ->
      @name = 'Error401'
      @message = message
      @stack = (new Error()).stack
    @Error401.prototype = new Error()

    @Error403 = (message) ->
      @name = 'Error403'
      @message = message
      @stack = (new Error()).stack
    @Error403.prototype = new Error()

    @Error404 = (message) ->
      @name = 'Error404'
      @message = message
      @stack = (new Error()).stack
    @Error404.prototype = new Error()
    # coffeelint: enable=missing_fat_arrows

  route: (verb, path, handlers...) =>
    if arguments.length is 0
      return @router

    @router[verb] path, (req, res) =>
      Promise.reduce handlers, (result, handler) ->
        unless _.isFunction handler
          throw new Error 'handler method not found'
        Promise.try handler, [req, res]
      , 0
      .then (result) ->
        if result is null
          return res.status(204).end()
        res.json result
      .catch @Handled, -> null
      .catch @Error400, (err) ->
        log.trace err
        res.status(400).json
          status: '400'
          detail: err.message
      .catch @Error401, (err) ->
        log.trace err
        res.status(401).json
          status: '401'
          detail: err.message
      .catch @Error403, (err) ->
        log.trace err
        res.status(403).json
          status: '403'
          detail: err.message
      .catch @Error404, (err) ->
        log.trace err
        res.status(404).json
          status: '404'
          detail: err.message
      .catch (err) ->
        log.trace err
        res.status(500).json
          status: '500'

  getExpressRouter: ->
    @router

module.exports = new Router()
