express	 = require 'express'
mongoose 	= require('mongoose');
sys		 = require 'sys'
util		= require 'util'
Controllers = require './controllers'

app = express()

app.configure () ->
	app.set 'port', 8080
	app.use express.favicon()
	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use express.session()

	app.use app.router

app.routeCall = (self, callback) ->
	(req, res) ->
		callback.call self, req, res

app.error = (error, res) ->
	app.message error.code, error.message, res

	# Log error with line number
	app.log.error util.inspect(error), __stack[1].getFileName() + ":" + __stack[1].getLineNumber()

app.default = (req, res, method_name) ->
	params = ''

	if req.params
		params = req.params

	response =
		data:
			success: true
			method: method_name
			params: params
			body: req.body
			query: req.query

	res.writeHead 200, "Content-Type": "application/json"
	res.write JSON.stringify response
	res.end()

app.message = (code, message, res) ->
	response = "message": message

	res.writeHead code, "Content-Type": "application/json"
	res.write JSON.stringify response
	res.end()

app.sendResponse = (data, res) ->
	res.writeHead 200, "Content-Type": "application/json"
	res.write JSON.stringify "data": data
	res.end()

app.controllers = new Controllers
	app: app,
	db: app.db,
	model: (name) ->
		app.models.model.call app.models, name

	component: (name) ->
		app.components.component.call app.components, name

app.controllers.routes();


server = require 'http'
server.createServer(app).listen app.get('port')

exports.app = app;