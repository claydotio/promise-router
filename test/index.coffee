flareGun = require 'flare-gun'
express = require 'express'
Promise = require 'bluebird'
bodyParser = require 'body-parser'
should = require('clay-chai').should()
Joi = require 'joi'
b = require 'b-assert'

router = require '../'

routes = router.getExpressRouter()
app = express()

app.use bodyParser.json()
app.use routes

flare = flareGun.express(app)

describe 'promise-router', ->
  it 'returns results', ->
    router.route 'get', '/test',
      -> {hello: 'world'}

    router.route 'get', '/test-promise',
      -> Promise.resolve {hello: 'world'}

    flare
      .get '/test'
      .expect 200, {hello: 'world'}
      .get '/test-promise'
      .expect 200, {hello: 'world'}

  it 'passes args', ->
    router.route 'post', '/args/:one/:two',
      (req) ->
        req.params.one.should.be '1'
        req.params.two.should.be '2'
        req.body.one.should.be '1'
        {}

    flare
      .post '/args/1/2', {one: '1'}
      .expect 200, {}

  it 'returns 204', ->
    router.route 'get', '/204',
      -> null

    flare
      .get '/204'
      .expect 204

  it 'ignores handled', ->
    router.route 'get', '/handled',
      (req, res) ->
        res.send 'test'
        throw new router.Handled()

    flare
      .get '/handled'
      .expect 200, 'test'

  it 'throws errors', ->
    router.route 'get', '/400',
      ->
        throw new router.Error {detail: 'test'}

    router.route 'get', '/401',
      ->
        throw new router.Error {status: 401, detail: 'test'}

    router.route 'get', '/403',
      ->
        throw new router.Error {status: 403, detail: 'test'}

    router.route 'get', '/404',
      ->
        throw new router.Error {status: 404, detail: 'test'}

    router.route 'get', '/500',
      -> throw new Error 'oops'

    flare
      .get '/400'
      .expect 400
      .get '/401'
      .expect 401
      .get '/403'
      .expect 403
      .get '/404'
      .expect 404
      .get '/500'
      .expect 500

  it 'asserts Joi schemas', ->
    router.assert {x: 'y'}, {x: Joi.string()}

    b ->
      router.assert {x: 'y'}, {x: Joi.number()}
    , (err) ->
      err.detail is 'child "x" fails because ["x" must be a number]'

    b ->
      router.assert {x: 'y'}, {}
    , (err) ->
      err.detail is '"x" is not allowed'

    b ->
      router.assert {x: 1}, {x: Joi.string()}
    , (err) ->
      err.detail is 'child "x" fails because ["x" must be a string]'

    b ->
      router.assert {x: '1'}, {x: Joi.number()}
    , (err) ->
      err.detail is 'child "x" fails because ["x" must be a number]'
