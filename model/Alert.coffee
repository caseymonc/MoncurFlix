gcm = require 'node-gcm'
apn = require 'apn'


class Alert
    sendAndroid: (regId,cb) ->
        message = new gcm.Message
        sender = new gcm.Sender 'AIzaSyC-zFCPDv3uVNeHXbFKPzh5XUBkpHGcfus'
        registrationIds = []
        message.addData "title", "Optik TV"
        message.addData "message", "This is a test from Jacob"
        registrationIds.push regId

        sender.send message, registrationIds, 4, (result) ->
          cb null, result

    sendIOS: (token, cb) ->

      error = (err,notification)  ->
        console.log err
        console.log notification

      options = {
          cert: 'cert_dev.pem',
          key:  'key.pem',
          gateway: 'gateway.sandbox.push.apple.com',
          port: 2195,
          errorCallback: error
      }


      apnsConnection = new apn.Connection options

      myDevice = new apn.Device token

      note = new apn.Notification

      note.payload = {
                "aps": {
                    "alert": "This is a test from Jacob",
                    "sound": "alert.caf",
                    "eventId": "10035 2012-11-15 20:00"
                }
              }
      note.device = myDevice

      apnsConnection.sendNotification note


      cb null, "Notification Sent."
      

module.exports = Alert