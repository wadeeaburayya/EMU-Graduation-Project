// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:covid_app/diabetes/main.dart';
import 'package:covid_app/screens/auth_screen.dart';
import 'package:covid_app/screens/home.dart';
import 'package:covid_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import './providers/user_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  runApp(CovidApp());
}

class CovidApp extends StatelessWidget {
  const CovidApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, appSnapshot) {
        FirebaseMessaging.instance.getToken();
        return ChangeNotifierProvider(
          create: (context) => UserData(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Covid 19 Tracking App',
            theme: ThemeData(
                primarySwatch: Colors.teal,
                backgroundColor: Colors.teal.shade800,
                accentColor: Colors.red,
                accentColorBrightness: Brightness.dark,
                buttonTheme: ButtonTheme.of(context).copyWith(
                  buttonColor: Colors.red,
                  textTheme: ButtonTextTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                textTheme:
                    const TextTheme(headline6: TextStyle(fontFamily: "Squid"))),
            home: appSnapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (ctx, userSnapshot) {
                      if (userSnapshot.hasData) {
                        return HomePage();
                      }
                      return AuthScreen();
                    }),
            routes: {
              '/profile': (context) => UserProfile(),
              '/diabetes': (context) => DiabetesRisk()
            },
          ),
        );
      },
    );
  }
}
