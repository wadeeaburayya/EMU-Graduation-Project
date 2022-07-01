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
    .onUpdate((change, context) => {
      const db = admin.firestore();
      // Get an object representing the document
      // e.g. {'name': 'Marie', 'age': 66}
      const newValue = change.after.data();
        
      // ...or the previous value before this update
      const previousValue = change.before.data();
      

      new_status = newValue.Covid;
      prev_status = previousValue.Covid;

      if((prev_status == -1 || prev_status == 1) && new_status == 0){
        db.collection('users').doc(context.params.userId).collection('contacts').get().then((snapshot)=>{
            snapshot.forEach(doc => {
              token = doc.data();
              admin.messaging().sendToDevice(token.token ,{notification: {title: "Alert!", body: newValue.username + " from your contact list is infected!"}}).catch((e)=>{print(e)})
            
        });})

       


      }
      else return;



      // perform desired operations ...
    });

    exports.createUser = functions.firestore
    .document('users/{userId}/collections/{contactId}')
    .onCreate((snap, context) => {
      // Get an object representing the document
      // e.g. {'name': 'Marie', 'age': 66}
      const newValue = snap.data();

      db.collection('users').doc(context.params.userId).get().then((user)=>{
        let x = user.data()
        if(x.Covid == 0){
            db.collection('users').doc(context.params.contactId).get().then((myToken)=>{
            myToken = myToken.data();
            if(myToken.Covid != -1 || myToken.Covid != 0){
            admin.messaging().sendToDevice(myToken.token ,{notification: {title: "Contacted!", body: 'You have been in contacts with an infected person'}}).catch((e)=>{print(e)})
          }
            })
            
      }})
      

      // access a particular field as you would any JS property

      // perform desired operations ...
    });