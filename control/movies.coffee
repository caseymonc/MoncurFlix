tmdb = require('tmdbv3').init('53a6bae19ce1f917f9c913f69e4c8fa0')
Tomatoes = require 'tomatoes'
tomatoes = Tomatoes 'jh3efhnsx822xuy5av2dnj65'
request = require 'request' 

module.exports = (Movie) ->

  getAllMovies: (req, res) ->
    Movie.getAllMovies (err, movies) ->
      return res.json {error: true, message: err.message}, 500 if err?
      res.json movies

  getMoviesByGenres: (req, res) ->
    genres = req.params.genres
    Movie.getMoviesByGenres genres, (err, movies) ->
      return res.json {error: true, message: err.message}, 500 if err?
      res.json movies

  getMoviesByRating: (req, res) ->
    rating = req.params.rating
    Movie.getMoviesByRating rating, (err, movies) ->
      return res.json {error: true, message: err.message}, 500 if err?
      res.json movies

  getGenreList: (req, res) ->
    tmdb.genre.list (err,result) ->
      res.json result

  searchMovie: (req, res) ->
    title = req.params.title
    tmdb.search.movie title, (err,result) ->
      tmdb.movie.info result.results[0].id, (err, movie) ->
        tomatoes.search title, (err, results) ->
          res.json createSchemaObjectFromSearchData mergeData movie, results[0]

    

  createMovie: (req, res) ->
    body = res.body
    movie = new Movie res.body
    movie.save (err) ->
      return res.json {error: true, message: err.message}, 500 if err?
      res.json movie


createSchemaObjectFromSearchData = (json) ->
  genre_array = []
  i = 0
  while i < json.genres.length
    genre_array.push json.genres[i].name
    i++

  actors_array = []
  j = 0
  while j < json.abridged_cast.length
    actors_array.push json.abridged_cast[j].name
    j++

  schema_object =
    title: json.title
    description: json.overview 
    length: json.runtime
    uploadDate: new Date
    genres: genre_array
    actors: actors_array
    imageUrl: json.posters.original
    rating: json.mpaa_rating

mergeData = (o1, o2) ->
  return o1  if not o1? or not o2?
  for key of o2
    o1[key] = o2[key]  if o2.hasOwnProperty(key)
  o1