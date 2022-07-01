// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:covid_app/providers/user_info.dart';
import 'package:covid_app/screens/bmi/input_page.dart';

class UserProfile extends StatefulWidget {
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Widget _builder(ctx, field, prop, [change]) {
    var prop1 = 1;
    if (prop == 'Null, Measure it!') prop1 = 0;
    return SizedBox(
      height: MediaQuery.of(ctx).size.height * 0.09,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        minLeadingWidth: 130,
        leading: Text(
          field,
          style: const TextStyle(
              decoration: TextDecoration.underline,
              fontFamily: 'Gothic',
              fontSize: 15,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.normal),
        ),
        subtitle: change != null && prop1 != 0
            ? change == 1
                ? double.parse(prop) < 18.5
                    ? const Text('Under-Weight')
                    : double.parse(prop) <= 25
                        ? const Text('Normal')
                        : const Text("Over-Weight")
                : prop < 6
                    ? const Text('Low')
                    : prop < 9
                        ? const Text('Low To Moderate')
                        : prop < 12
                            ? const Text('Moderate')
                            : prop < 16
                                ? const Text('Moderate to High')
                                : prop < 20
                                    ? const Text('High')
                                    : const Text('Very High')
            : null,
        title: Text(
          prop.toString(),
          style: const TextStyle(
              // fontFamily: 'Gothic',
              fontSize: 15,
              fontWeight: FontWeight.normal),
        ),
        trailing: change != null
            ? Padding(
                padding: const EdgeInsets.only(right: 20),
                child: InkWell(
                  child: const Icon(Icons.edit),
                  onTap: () {
                    change == 1
                        ? Navigator.push(
                            ctx,
                            MaterialPageRoute(
                                builder: (context) => InputPage()),
                          )
                        : Navigator.of(context).pushNamed('/diabetes');
                  },
                ),
              )
            : null,
      ),
    );
  }

  Widget titleStatus(int x) {
    return Text(
      x == 1
          ? "You are healthy!"
          : x == 0
              ? "Self-Isolate!"
              : "Take A PCR Test!",
      style: TextStyle(
          fontFamily: 'Gothic',
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: x == 1
              ? Colors.green
              : x == 0
                  ? Colors.red
                  : Colors.orange),
    );
  }

  @override
  Widget build(BuildContext context) {
    var x = Provider.of<UserData>(context, listen: true);
    DocumentSnapshot<Map<String, dynamic>> info = x.getData();
    final status = info.data()["Covid"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("SafeCircle"),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2,
              child: titleStatus(status)),
          Column(
            children: [
              _builder(context, "Username:", info.data()['username']),
              const Divider(),
              _builder(
                  context, "Email:", FirebaseAuth.instance.currentUser.email),
              const Divider(),
              _builder(
                  context,
                  "Covid Status:",
                  status == 1
                      ? 'Healthy'
                      : status == 0
                          ? 'Infected'
                          : 'Waiting'),
              const Divider(),
              _builder(
                  context,
                  "BMI:",
                  info.data()['BMI'] == 0
                      ? "Null, Measure it!"
                      : info.data()['BMI'],
                  1),
              const Divider(),
              _builder(
                  context,
                  "Diabetes Risk:",
                  info.data()['Diabetes'] == 0
                      ? "Null, Measure it!"
                      : info.data()['Diabetes'],
                  2),
            ],
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.15,
            child: const Text(
              "Incase of Emergency call: \n0533 859 73 48",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.teal,
                  fontFamily: "Gothic",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
