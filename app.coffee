express = require 'express'

Mongoose = require 'mongoose'
Movie = require './model/Movie'
MoviesController = require './control/movies'
UserController = require './control/users'
User = require './model/User'
GroupController = require './control/groups'
Group = require './model/Group'
passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
FacebookStrategy = require('passport-facebook').Strategy


DB = process.env.DB || 'mongodb://localhost:27017/moncurflix'
db = Mongoose.createConnection DB
movie = Movie db
moviesController = MoviesController movie
user = User db
userController = UserController user
group = Group db
groupController = GroupController group

exports.createServer = ->
  app = express.createServer()

  passport.use(new LocalStrategy (username, password, done) ->
      user.findOne({ username: username, password: password }, (err, user) ->
        done(err, user)

  passport.use(new FacebookStrategy {clientID: "FACEBOOK_APP_ID", clientSecret: "FACEBOOK_APP_SECRET", callbackURL: "http://localhost:2055/auth/facebook/callback"}, (accessToken, refreshToken, profile, done) ->
    user.findOrCreate(..., (err, user) ->
      if err then return done(err) else done(null, user)

  passport.serializeUser (user, done) ->
    done(null, user.id)

  passport.deserializeUser (id, done) ->
    user.findById(id, function (err, user) ->
      done(err, user)

  app.configure () ->
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use(express.session({ secret: 'keyboard cat' }))
    app.use(passport.initialize())
    app.use(passport.session())
    app.use express.cookieParser('OnGhigyosacPevBaspebyewUtkapvidatsAlkEypyeukAwthax')
    app.use app.router
    app.use(express.static(__dirname + '/../../public'))


  app.get "/", (req, res) ->
    res.contentType ".txt"
    res.send """
      MoncurFlix Service
    """

  


  # GET
  #
  # returns all movies in the database
  #
  app.get '/movies/all', passport.authenticate('local'), moviesController.getAllMovies

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


  # GET
  #
  # returns the group with id groupId
  app.get '/group/:groupId', groupController.getGroup

  # POST
  # { 
  #   name: 'Moncur Family'
  # }
  # creates a group
  app.post '/group', groupController.createGroup

  # GET
  #
  # returns the user with :email
  app.get '/user/:email', userController.getUser

  # GET
  #
  # returns the user with :email
  app.get '/user/:email/permissions', userController.getUserPermissions

  # POST
  # {
  #   email: 'caseymonc@gmail.com'
  #   password: 'password'
  #   group: (GroupId)
  # }
  # creates a user
  app.post '/user', userController.createUser

  # DELETE
  #
  # returns the user with id userId
  app.delete '/user/:email', userController.deleteUser


  app.get '/auth/facebook', passport.authenticate('facebook')

  app.get '/auth/facebook/callback', passport.authenticate('facebook', { successRedirect: '/', failureRedirect: '/login' })

  # final return of app object
  app

if module == require.main
  app = exports.createServer()
  app.listen 2055
  console.log "Running MoncurFlix Service"