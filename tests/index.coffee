Flare = require 'flare-gun'
express = require 'express'
Promise = require 'bluebird'
bodyParser = require 'body-parser'
should = require('clay-chai').should()

router = require '../'

routes = router.getExpressRouter()
app = express()

app.use bodyParser.json()
app.use routes

flare = new Flare().express(app)

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

  it 'throws errors', ->
    router.route 'get', '/400',
      ->
        throw new router.Error400 'test'

    router.route 'get', '/401',
      ->
        throw new router.Error401 'test'

    router.route 'get', '/403',
      ->
        throw new router.Error403 'test'

    router.route 'get', '/404',
      ->
        throw new router.Error404 'test'

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