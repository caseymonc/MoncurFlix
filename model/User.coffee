mongoose = require 'mongoose'
Schema = mongoose.Schema
Movie = require './Movie'
Group = require './Group'

# User Model
module.exports = (db) ->

  UserSchema = new Schema {
    email: {type: String, required:true, unique: true}
    password: {type: String, required:true} 
    name: String
    recent: [String]
    favorites: [String]
    seen: [{movieId: String, count: Number}]
    picture: String
    defaultMovieRating: String
    defaultMovieFilters: [String]
    permissions: {type: [{type: String, enum: ['Upload', 'ChangeDefaultRating', 'ChangeDefaultFilters', 'CreateFilter', 'ChangeUserPermissions', 'Admin']}], default: ['Upload', 'ChangeRating', 'CreateFilter', 'ChangeUserGroupPermissions']}
    group: String
  }


  # Get All Users for a group
  UserSchema.statics.getUsersByGroup = (group, cb) ->
    @where("group").in(group).exec cb

  # Get a user by id
  UserSchema.statics.getUser = (email, cb) ->
    @findOne({"email": email}).exec cb

  # Mark a movie as watched
  # 1. Add it to the recent movies list
  # 2. Add it to the seen list
  UserSchema.watchMovie = (movieId, cb) =>
    result = (item for item in @seen when item.movieId is movieId)
    if result
      result.count++
    else
      @seen.push {"movieId" : movieId, "count" : 1}

    @recent.push movieId
    @save()

  # Add a movie to the User's favorites list
  UserSchema.addFavorite = (movieId) =>
    @favorites.push movieId
    @save()

  # Get all of a user's favorites
  UserSchema.getFavorites = () =>
    Movie.getMovies @favorites (err, res) ->
      return res.json {error: true, message: err.message}, 500 if err?
      res.json movies

  User = db.model "User", UserSchema