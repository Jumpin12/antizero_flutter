const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.onCreateNotificationItem = functions.firestore
    .document("/users/{userId}/notification/{notificationItem}")
  .onCreate(async (snapshot, context) => {
    console.log("PeopleRequest Created", snapshot.data());

    // 1) Get user connected to the notification
    const userId = context.params.userId;

    const userRef = admin.firestore().doc(`users/${userId}`);
    console.log(userId);
    const doc = await userRef.get();

    // 2) Get user token
    const notificationToken = doc.data().token;
    const createdNotificationItem = snapshot.data();
    const title = createdNotificationItem.msgBody.title;
    const body = createdNotificationItem.msgBody.msg;

    if (notificationToken) {
      sendNotification(notificationToken, createdNotificationItem);
    } else {
      console.log("No token for user, cannot send notification");
    }

    function sendNotification(notificationToken, notificationItem) {

      // 3) Create message for push notification
      const message = {
        notification: {
            title: title,
            body: body
        },
        token: notificationToken,
        data: { recipient: userId, description: description }
      };

      // 4) Send message with admin.messaging()
      admin
        .messaging()
        .send(message)
        .then(response => {
          console.log("Successfully sent message", response);
        })
        .catch(error => {
          console.log("Error sending message", error);
        });
    }
  });

//http function to return all users within a certain distance of a given lat and long
exports.getUsersWithinDistance = functions.https.onRequest((req, res) => {
  const lat = req.query.lat;
  const lon = req.query.lon;
  const distance = req.query.distance;
  const usersRef = admin.firestore().collection("users");
  usersRef.get().then(snapshot => {
    const users = [];
    snapshot.forEach(doc => {
      const user = doc.data();
      const userLat = user.lat;
      const userLon = user.lon;
      const userDistance = getDistance(lat, lon, userLat, userLon);
      if (userDistance <= distance) {
        users.push(user);
      }
    });
    res.send(users);
  });
});

//http function to get users within a certain age group
exports.getUsersWithinAgeGroup = functions.https.onRequest((req, res) => {
  const age = req.query.age;
  const usersRef = admin.firestore().collection("users");
  usersRef.get().then(snapshot => {
    const users = [];
    snapshot.forEach(doc => {
      const user = doc.data();
      const userAge = user.age;
      if (userAge >= age) {
        users.push(user);
      }
    });
    res.send(users);
  });
});

//http function to randomize users
exports.randomizeUsers = functions.https.onRequest((req, res) => {
  const usersRef = admin.firestore().collection("users");
  usersRef.get().then(snapshot => {
    const users = [];
    snapshot.forEach(doc => {
      const user = doc.data();
      users.push(user);
    });
    const randomUsers = [];
    while (users.length > 0) {
      const randomIndex = Math.floor(Math.random() * users.length);
      randomUsers.push(users[randomIndex]);
      users.splice(randomIndex, 1);
    }
    res.send(randomUsers);
  });
});