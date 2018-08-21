const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase Dreamerongo!");
});

exports.sendPushNotifications = functions.https.onRequest((req, res) => {
    res.send("Attempting to send push notifications");

    console.log("LOGGER --- Trying to send push message...");

    //  admin.message().sendToDevice(token, payload)

    // This registration token comes from the client FCM SDKs.
    var fcmToken = 'eSMLJEioTy0:APA91bFAdsk0BLeHKdSPCk82kiJ_SFwNnOaOAcKPgL_DrLYECpZh-iTuTAlw1WXmsI8HLisLyWO_I2OPEsMAMslhoXv0ir-rQLo5X1V1Gt0ydMUhUlMdjUk2Fi3EiOZodoclJjCczW28qGOndWAjK8XdX8FHekXcsQ';

    // See documentation on defining a message payload.
    var message = {
        notification: {
            title: "Push notification TITLE HERE",
            body: "Body over here is our message body..."
        },
    data: {
        score: '850',
        time: '2:45'
    },
    token: fcmToken
    };

    // Send a message to the device corresponding to the provided
    // registration token.
    admin.messaging().send(message).then((response) => {
        // Response is a message ID string.
        console.log('Successfully sent message:', response);
        return response;
    }).catch((error) => {
        console.log('Error sending message:', error);
    });
    
})
