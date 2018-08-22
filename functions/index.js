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

// listen for Following events and then trigger a push notification
exports.observeFollowing = functions.database.ref('/following/{uid}/{followingId}')
    .onCreate((snapshot, context) => {
     //   const original = snapshot.val();
        var uid = context.params.uid;
        var followingId = context.params.followingId;

        console.log('User: ', uid, ' is following ', followingId);

        return admin.database().ref('/users/' + followingId).once('value', snapshot => {
            var userWeAreFollowing = snapshot.val();
            return admin.database().ref('/users/' + uid).once('value', snapshot => {
                var userDoingTHeFollowing = snapshot.val();
                var message = {
                    notification: {
                        title: "You have a new follower",
                        body: userDoingTHeFollowing.username + ' is now following you'
                    }
                }
                console.log("This is the users fcmToken we are following: ", userWeAreFollowing.fcmToken);
                admin.messaging().sendToDevice(userWeAreFollowing.fcmToken, message)
                    .then(response => {
                        console.log('Successfully sent this message from observeFollowing function:', response);
                        return response;
                    })
                    .catch((error) => {
                        console.log('Error sending this particular message:', error);
                    });
            })
        })
    })

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
