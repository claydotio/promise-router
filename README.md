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
  throw new router.Error status: 400, detail: 'not found'

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

##### assert(obj, schema)

Failure throws 400 errors with Joi message

```
@param {*} obj
@param {JoiSchema} schema
```

##### getExpressRouter()

```
@returns ExpressRouter
```

##### new Error({status, detail})

```
@constructor
@param opts
@param opts.status
@param opts.detail
@returns RouterError
```

##### 500 errors

Just throw
