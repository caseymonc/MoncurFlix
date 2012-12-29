module.exports = (alert) ->

  sendAlerts: (req, res) ->
    device = req.params.device
    token = req.params.token

    if device == "android"
      alert.sendAndroid token, (err, result) ->
        return res.send err.message 500 if err?
        res.send result
    else
      alert.sendIOS token, (err, result) ->
        return res.send err.message 500 if err?
        res.send result