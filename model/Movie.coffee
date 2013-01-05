mongoose = require 'mongoose'
Schema = mongoose.Schema

# User Model
module.exports = (db) ->

  MovieSchema = new Schema {
    title: String
    description: String 
    length: Number
    uploadDate: Date
    genres: [String]
    actors: [String]
    imageUrl: String
    movieUrl: String
    filters: [{
        filterType: String 
        startTime: Number
        endTime: Number
        length: Number
        rating: String
      }]
    recommendedBy:[String]
    rating: String
    uploadedBy: String

  }

  MovieSchema.statics.getAllMovies = (cb) ->
    @find().exec cb

  MovieSchema.statics.getMoviesByGenres = (genres, cb) ->
    @where("genres").in(genres).exec cb

  MovieSchema.statics.getMoviesByRating = (rating, cb) ->
    if rating is 'r'
      rating_array = ['r','pg13','pg','g']
    else if rating is 'pg13'
      rating_array = ['pg13','pg','g']
    else if rating is 'pg'
      rating_array = ['pg','g']
    else
      rating_array = ['g']

    @where("rating").in(rating_array).exec cb

  MovieSchema.statics.getMoviesByIds = (ids, cb) ->
    @where("_id").in(ids).exec cb

  Movie = db.model "Movie", MovieSchema