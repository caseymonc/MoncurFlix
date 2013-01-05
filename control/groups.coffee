module.exports = (Group) ->
	createGroup = (req, res)->
		body = req.body
		group = new Group body
		group.save(err) ->
			return res.json {error: true, message: err.message}, 500 if err?
			res.json group

	getGroup = (req, res) ->
		group = req.params.groupId
		Group.getGroup group (err, group) ->
			return res.json {error: true, message: err.message}, 500 if err?
			res.json group
