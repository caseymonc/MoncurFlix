mongoose = require 'mongoose'
Schema = mongoose.Schema
User = require './User'

# User Model
module.exports = (db) ->

  GroupSchema = new Schema {
    name: {type: String, required:true}
    users: [User.ObjectId] 
    globalDefaultMovieFilters: [String]
  }

  GroupSchema.statics.getGroup = (groupId, cb) ->
    @findOne({"_id" : groupId}).exec cb

  GroupSchema.statics.deleteGroup = (groupId, cb) ->
    @findOne({"_id" : groupId}).exec (err, group) ->
      group.remove()
      cb {""}
  

  Group = db.model "Group", GroupSchema