import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserBalance extends StatefulWidget {
  @override
  _UserBalanceState createState() => _UserBalanceState();
}

class _UserBalanceState extends State<UserBalance> {
  String userBalance = '';

  @override
  void initState() {
    super.initState();

    // this might need to be a stream
    User? currentUser = FirebaseAuth.instance.currentUser;
    setUserInfo(currentUser!.uid);
  }

  void setUserInfo(uid) {
    // a stream instead of active polling
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      setState(() {
        userBalance = documentSnapshot.data()!['balance'].toString();
      });
    }).onError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Your Balance is: \$',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        Text(
          userBalance,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
