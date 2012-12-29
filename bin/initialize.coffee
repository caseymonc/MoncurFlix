express = require 'express'
Mongoose = require 'mongoose'
Movie = require './model/Movie'
MoviesController = require './control/movies'
DB = process.env.DB || 'mongodb://localhost:27017/moncurflix'
db = Mongoose.createConnection DB
movie = Movie db
moviesController = MoviesController movie

movie1 = new Movie {title:'Seven Pounts', description:'A really good movie with will smith'}
