// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:covid_app/providers/user_info.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Strategy strategy = Strategy.P2P_STAR;
  List<dynamic> contactTraces = [];
  List<dynamic> contactTimes = [];
  List<dynamic> contactStatuses = [];
  var loading;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User loggedInUser = FirebaseAuth.instance.currentUser;

  void addContactsToList() async {
    loading = 1;
    final myStatus = await getStatuses(loggedInUser.uid);
    _firestore
        .collection('users')
        .doc(loggedInUser.uid)
        .collection('contacts')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        loading = 0;
      }
      for (var doc in snapshot.docs) {
        String currUsername = doc.data()['username'];
        print(currUsername);
        var id = doc.id;
        print(id);
        DateTime currTime = doc.data().containsKey('Time')
            ? (doc.data()['Time'] as Timestamp).toDate()
            : null;

        getStatuses(id).then((status) {
          if (status == 0 && myStatus != -1) {
            _firestore
                .collection('users')
                .doc(loggedInUser.uid)
                .update({'Covid': -1});

            Provider.of<UserData>(context, listen: false).getUserInfo();
          }
          if (!contactTraces.contains(currUsername)) {
            contactTraces.add(currUsername);
            contactTimes.add(currTime);
            print(status);
            contactStatuses.add(status);
          }
          setState(() {
            loading = 0;
          });
        }).catchError((e) {});
      }
      setState(() {
        print(loggedInUser.email);
      });
    });
  }

  Future<int> getStatuses(id) async {
    final info = await _firestore.collection('users').doc(id).get();
    return info.data()['Covid'];
  }

  void deleteOldContacts() async {
    loggedInUser = FirebaseAuth.instance.currentUser;
    DateTime timeNow = DateTime.now(); //get today's time

    _firestore
        .collection('users')
        .doc(loggedInUser.uid)
        .collection('contacts')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
//        print(doc.data.containsKey('contact time'));
        if (doc.data().containsKey('Time')) {
          DateTime contactTime = (doc.data()['Time'] as Timestamp)
              .toDate(); // get last contact time
          // if time since contact is greater than threshold than remove the contact
          if (timeNow.difference(contactTime).inDays > 14) {
            doc.reference.delete();
          }
        }
      }
    });

    setState(() {});
  }

  Future<String> getUsernameOfEmail({String id}) async {
    var res = '';
    await _firestore.collection('users').doc(id).get().then((doc) {
      if (doc.exists) {
        res = doc.data()['username'];
      } else {
        // doc.data() will be undefined in this case
        print("No such document!");
      }
    });
    return res;
  }

  Future<String> getTokenOfEmail({String id}) async {
    var res = '';
    await _firestore.collection('users').doc(id).get().then((doc) {
      if (doc.exists) {
        res = doc.data()['token'];
      } else {
        // doc.data() will be undefined in this case
        print("No such document!");
      }
    });
    return res;
  }

  void discovery() async {
    try {
      bool a = await Nearby().startDiscovery(loggedInUser.uid, strategy,
          onEndpointFound: (id, name, serviceId) async {
        print('I saw id:$id with name:$name'); // the name here is an email

        var docRef = _firestore.collection('users').doc(loggedInUser.uid);

        //  When I discover someone I will see their email and add that email to the database of my contacts
        //  also get the current time & location and add it to the database
        docRef.collection('contacts').doc(name).set({
          'username': await getUsernameOfEmail(id: name),
          'Time': DateTime.now(),
          'token': await getTokenOfEmail(id: name)
        });
      }, onEndpointLost: (id) {
        print(id);
      });
      print('DISCOVERING: ${a.toString()}');
    } catch (e) {
      print(e);
    }
  }

  void getPermissions() async {
    Nearby().askLocationPermission();
    if (!await Nearby().checkLocationEnabled()) {
      try {
        await Nearby().enableLocationServices();
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    deleteOldContacts();
    addContactsToList();
    getPermissions();
    startAdvertising();
  }

  @override
  void dispose() {
    super.dispose();
    Nearby().stopAdvertising();
    Nearby().stopDiscovery();
  }

  void startAdvertising() async {
    try {
      // loading = 1;
      bool a = await Nearby().startAdvertising(
        loggedInUser.uid,
        strategy,
        onConnectionInitiated: null,
        onConnectionResult: (id, status) {
          print(status);
        },
        onDisconnected: (id) {
          print('Disconnected $id');
        },
      );

      print('ADVERTISING ${a.toString()}');
    } catch (e) {
      print(e);
    }

    discovery();
    loading = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.30,
          child: Image.asset('assets/images/Contact-Tracing.png'),
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(5),
        ),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.05,
          child: const Text(
            "Your Contacts List",
            style: TextStyle(
                fontFamily: 'Gothic',
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.red),
          ),
        ),
        Expanded(
          child: loading == 1
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  padding: const EdgeInsets.all(10),
                  margin:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          leading: Image.asset('assets/images/covid19.png'),
                          title: Text(
                            contactTraces[index],
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontFamily: 'Gothic', color: Colors.teal),
                          ),
                          subtitle: Text(
                            DateFormat.yMMMd()
                                .format(contactTimes[index])
                                .toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          trailing: Text(
                            contactStatuses[index] == 1
                                ? "Healthy"
                                : contactStatuses[index] == 0
                                    ? 'Infected'
                                    : 'waiting',
                            style: TextStyle(
                                fontFamily: 'Gothic',
                                color: contactStatuses[index] == 0
                                    ? Colors.red
                                    : contactStatuses[index] == 1
                                        ? Colors.teal
                                        : Colors.orange),
                          ),
                        ),
                      );
                    },
                    itemCount: contactTraces.length,
                  ),
                ),
        )
      ],
    );
  }
}
