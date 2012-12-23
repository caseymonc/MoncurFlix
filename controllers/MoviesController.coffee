class MoviesController
	contructor: (@sys) ->

	get: (request, result) => return @sys.app.default request, result, 'movies get'

	post: (request, result) => return @sys.app.default request, result, 'movies get'

	get: (request, result) => return @sys.app.default request, result, 'movies get'


	init: =>
		@sys.app.get '/movies' @sys.controller('auth').check(true), @get

		@sys.app.post '/movies/:movieId' @sys.controller('auth').check(true), @post

		@sys.app.put '/movies/:movieId' @sys.controller('auth').check(true), @put