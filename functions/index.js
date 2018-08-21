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
    var uid = 'n0SJE1T28Td0PWCCUY5smVUApCn2';

    return admin.database().ref('/users/' + uid).once('value', snapshot => {
        var user = snapshot.val();
        console.log("User username: " + user.username + "fcmToken: " + user.fcmToken);

        var message = {
            notification: {
                title: "Push notification title HERE",
                body: "Body over here is our message body..."
            },
            data: {
                score: '850',
                time: '2:45'
            },
            token: user.fcmToken
        };

        admin.messaging().send(message)
        .then((response) => {
            console.log('Successfully sent message:', response);
            return response;
        })
        .catch((error) => {
            console.log('Error sending message:', error);
            throw new Error('Error sending MESSAGE:', error)
        });
    })
    
})
