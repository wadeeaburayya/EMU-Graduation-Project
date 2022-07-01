const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
exports.updateStatus = functions.firestore
    .document('users/{userId}')
    .onUpdate(async (change, context) => {
      const db = admin.firestore();
      // Get an object representing the document
      // e.g. {'name': 'Marie', 'age': 66}
      const newValue = change.after.data();
      let tokens = [];
        
      // ...or the previous value before this update
      const previousValue = change.before.data();
      

      new_status = newValue.Covid;
      prev_status = previousValue.Covid;

      if(newValue.pcr_time != previousValue.pcr_time && new_status==1) {
        const snapshot = await db.collection('users').doc(context.params.userId).collection('contacts').get();
        snapshot.docs.forEach(doc => {
            await doc.delete();
        })
      }
      if((prev_status == -1 || prev_status == 1) && new_status == 0){
       const snapshot = await db.collection('users').doc(context.params.userId).collection('contacts').get();
        snapshot.forEach(doc => {
            let info = await db.collection('users').doc(doc.id).get();
            tokens.push(info.data().token);
            await db.collection('users').doc(doc.id).update({'Covid': -1});
        });

      }
      else return;

      return admin.messaging().sendMulticast({notification: {title: "Alert!", body: newValue.username + "from your contact list is infected!"}, tokens})


      // perform desired operations ...
    });

    exports.createUser = functions.firestore
    .document('users/{userId}/collections/{contactId}')
    .onCreate(async (snap, context) => {
      // Get an object representing the document
      // e.g. {'name': 'Marie', 'age': 66}
      const newValue = snap.data();

      const user = await db.collection('users').doc(context.params.contactId).get();
      if(user.data().Covid == 0){
        let myToken = await db.collection('users').doc(context.params.userId).get();
        myToken = myToken.data().token
        await db.collection('users').doc(context.params.userId).update({'Covid': -1});
        return admin.messaging().send({token: myToken, notification: {title: 'Alert', body: 'One Of Contacts Is Infected'}})
      }

      // access a particular field as you would any JS property

      // perform desired operations ...
    });