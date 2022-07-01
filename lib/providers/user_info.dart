import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class UserData with ChangeNotifier {
  DocumentSnapshot<Map<String, dynamic>> userInfo;

  UserData() {}

  Future getUserInfo() async {
    userInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    notifyListeners();
    return;
  }

  Future<DocumentSnapshot> updateUserInfo() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
  }

  DocumentSnapshot getData() {
    return userInfo;
  }

  String getUserName() {
    return userInfo.data()['username'];
  }

  Future<void> submitBMI(bmiInfo) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({'BMI': bmiInfo});
  }

  Future<void> submitDiabetes(diabetes) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({'Diabetes': diabetes});
  }
}
