_ = require 'lodash'
Promise = require 'bluebird'
express = require 'express'
log = require 'loga'

class Router
  constructor: ->
    @router = express.Router({caseSensitive: true})

    # coffeelint: disable=missing_fat_arrows
    @Handled = -> null
    @Handled.prototype = new Error()

    @Error = ({@status, @detail}) ->
      @status ?= 400
      @name = 'Error'
      @message = "Error #{@status}"
      @stack = (new Error()).stack
    @Error.prototype = new Error()
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
      .catch @Error, (err) ->
        log.error err
        res.status(err.status).json
          status: "#{err.status}"
          detail: err.detail
      .catch (err) ->
        log.error err
        res.status(500).json
          status: '500'

  getExpressRouter: =>
    @router

module.exports = new Router()
