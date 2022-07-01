// ignore_for_file: prefer_final_fields, unused_field, use_key_in_widget_constructors, deprecated_member_use, prefer_const_constructors

import 'package:covid_app/screens/nearby_devices_screen.dart';
import 'package:covid_app/screens/report_screen.dart';
import 'package:covid_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import "package:covid_app/providers/user_info.dart";
import "package:provider/provider.dart";
import 'package:nearby_connections/nearby_connections.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> pages = [HomeScreen(), ReportScreen()];
  var _selectedPage = 0;
  void selectPage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  void android12Perm() async {
    if (!await Nearby().checkBluetoothPermission()) {
      Nearby().askBluetoothPermission();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    FirebaseMessaging.onMessage.listen((message) {
      print(message);
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message);
      return;
    });
  }

  @override
  void didChangeDependencies() async {
    Provider.of<UserData>(context, listen: false).getUserInfo();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    android12Perm();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: const Text("SafeCircle"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              icon: const Icon(Icons.account_circle_outlined))
        ],
      ),
      drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: DrawerWidget()),
      body: pages[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: selectPage,
        currentIndex: _selectedPage,
        type: BottomNavigationBarType.shifting,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColorDark,
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColorDark,
            icon: Icon(Icons.newspaper),
            label: "Report",
          )
        ],
      ),
    );
  }
}
