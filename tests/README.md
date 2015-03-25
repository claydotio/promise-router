# promise-router

Extends the default express 4.x router

```
npm i -S promise-router
```

### Example

```coffee
router = require 'promise-router'

router.route 'get', '/test', (req, res) ->
  {test: 'hi'}
router.route 'get', '/404', ->
  throw new router.Error404 'missing'

app = express()
app.use router.getExpressRouter()
```

### Methods

##### route(method, path, handlers...)

```
@param String method
@param String path
@param Function... handlers
```

##### getExpressRouter()

```
@returns ExpressRouter
```

##### new Error400(message)

```
@constructor
@param message
@returns Error400
```

##### new Error401(message)

```
@constructor
@param message
@returns Error401
```

##### new Error403(message)

```
@constructor
@param message
@returns Error403
```

##### new Error404(message)

```
@constructor
@param message
@returns Error404
```

##### new Error500(message)

```
@constructor
@param message
@returns Error500
```
