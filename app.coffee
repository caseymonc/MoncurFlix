express = require 'express'

Mongoose = require 'mongoose'
Movie = require './model/Movie'
MoviesController = require './control/movies'

DB = process.env.DB || 'mongodb://localhost:27017/moncurflix'
db = Mongoose.createConnection DB
movie = Movie db
moviesController = MoviesController movie

exports.createServer = ->
  app = express.createServer()

  app.get "/", (req, res) ->
    res.contentType ".txt"
    res.send """
      MoncurFlix Service
    """

  # GET
  #
  # returns all movies in the database
  #
  app.get '/movies/all', moviesController.getAllMovies

  # GET
  #
  # returns all movies in the database with given genres
  # genres needs to be an array of genres - ['Thriller', 'Action', 'Romantic']
  #
  app.get '/movies/:genres/genres', moviesController.getMoviesByGenres

  # GET
  #
  # returns all movies in the database at and below the given rating
  # ratings given as lowercase strings - G, PG, PG-13, R
  #
  app.get '/movies/:rating/rating', moviesController.getMoviesByRating

  # GET
  #
  # returns top result from tmdb and rotten tomatoes (see http://docs.themoviedb.apiary.io/  && http://developer.rottentomatoes.com/docs)
  #
  app.get '/movies/:title/search', moviesController.searchMovie

  # POST
  #
  # creates a new movie object in the database with whatever information its given
  # {
  #   title: 'Seven Pounds'
  #   description: 'Really awesome movie about something really cool'
  #   imageUrl: 'www.someimageurl.com/asdkfjljasdf.jpg'
  #   movieUrl: 'www.amazons3'
  #   ... see movie model for more
  # }
  app.post '/movies/createNew', moviesController.createMovie


  # GET
  #
  # returns a list of movie genres
  #
  app.get '/genre/list', moviesController.getGenreList

  # final return of app object
  app

if module == require.main
  app = exports.createServer()
  app.listen 2055
  console.log "Running MoncurFlix Service"