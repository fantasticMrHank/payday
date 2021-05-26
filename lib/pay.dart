import 'package:payday/login.dart';
import 'package:payday/shared/balanceDisplay.dart';
import 'package:payday/shared/pay_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PayScreen extends StatefulWidget {
  static String id = 'Pay_Screen';
  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  final _auth = FirebaseAuth.instance;
  String userName = '';

  @override
  void initState() {
    super.initState();
    User currentUser = FirebaseAuth.instance.currentUser!;
    setUserInfo(currentUser.uid);
  }

  void setUserInfo(uid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        userName = documentSnapshot.data()!['name'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bonfire Ads"),
        centerTitle: true,
        backgroundColor: Colors.amber,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.popAndPushNamed(context, LoginScreen.id);
              },
              icon: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      drawer: Container(
        width: 200,
        child: PayDrawer('pay'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserBalance(),
          ],
        ),
      ),
    );
  }
}
