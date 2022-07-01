// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/bmi/input_page.dart';
import 'package:provider/provider.dart';
import 'package:covid_app/providers/user_info.dart';
import 'package:nearby_connections/nearby_connections.dart';

class DrawerWidget extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables

  @override
  Widget build(BuildContext context) {
    final username =
        Provider.of<UserData>(context, listen: false).getUserName();
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            // borderRadius: BorderRadius.only(
            //     bottomLeft: Radius.circular(15),
            //     bottomRight: Radius.circular(15))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SafeCricle',
                style: TextStyle(
                    fontFamily: 'Squid',
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(FirebaseAuth.instance.currentUser.email,
                      style: const TextStyle(fontSize: 10, color: Colors.black))
                ],
              ),
            ],
          ),
        ),
        const ListTile(
          title: Text(
            'Home',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          onTap: null,
        ),
        const SizedBox(height: 15),
        const Divider(),
        ListTile(
          minLeadingWidth: 10,
          leading: const Icon(Icons.edit_note_outlined),
          title: const Text('Measure BMI'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InputPage()),
            );
          },
        ),
        const Divider(),
        ListTile(
          minLeadingWidth: 10,
          leading: const Icon(Icons.edit_note_outlined),
          title: const Text(
            'Measure Diabetes Risk',
            textAlign: TextAlign.start,
          ),
          onTap: () {
            Navigator.of(context).pushNamed('/diabetes');
          },
        ),
        const SizedBox(
          height: 40,
        ),
        Container(
          alignment: Alignment.centerLeft,
          width: 100,
          child: TextButton.icon(
            icon: const Icon(Icons.logout_outlined),
            label: const Text('Logout'),
            onPressed: () {
              // Nearby().stopAdvertising();
              // Nearby().stopDiscovery();
              FirebaseAuth.instance.signOut();
            },
          ),
        )
      ],
    );
  }
}
