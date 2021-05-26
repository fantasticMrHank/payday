import 'package:payday/ads.dart';
import 'package:payday/login.dart';
import 'package:payday/shared/balanceDisplay.dart';
import 'package:payday/shared/pay_drawer.dart';
import 'package:payday/shared/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static String id = 'Profile_Screen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  String userName = '';
  String userEmail = '';
  String userID = '';
  double initialBalance = 0;
  @override
  void initState() {
    super.initState();

    User? currentUser = _auth.currentUser;
    userID = currentUser!.uid;
    checkIfDocExists(currentUser);
  }

  void setUserInfo(uid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        userName = documentSnapshot.data()!['name'];
        userEmail = documentSnapshot.data()!['email'];
      });
    });
  }

  Future<void> checkIfDocExists(User user) async {
    var collectionRef = FirebaseFirestore.instance.collection('users');
    var doc = await collectionRef.doc(user.uid).get();
    if (doc.exists) {
      setUserInfo(user.uid);
      // user already exists, don't create
    } else {
      // user doesn't exist yet, create record for him/her
      collectionRef.doc(user.uid).set({
        'email': userEmail,
        'name': userName,
        'balance': initialBalance
      }).then((value) {
        setUserInfo(user.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _controllerUserName = TextEditingController();
    final _controllerUserEmail = TextEditingController();

    _controllerUserName.text = userName;
    _controllerUserEmail.text = userEmail;

    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
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
        child: PayDrawer('account'),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'User Name',
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _controllerUserName,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      userName = value;
                    },
                    decoration:
                        inputStyle.copyWith(hintText: 'Enter User Name'),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'User Email',
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _controllerUserEmail,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      userEmail = value;
                    },
                    decoration:
                        inputStyle.copyWith(hintText: 'Enter User Email'),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Paypal Account',
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {},
                    decoration:
                        inputStyle.copyWith(hintText: 'Enter Paypal account'),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Material(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () {
                        var collectionRef =
                            FirebaseFirestore.instance.collection('users');
                        collectionRef.doc(userID).update({
                          'name': userName,
                          'email': userEmail,
                        }).then((value) {
                          Navigator.popAndPushNamed(context, AdsScreen.id);
                        });
                      },
                      minWidth: 300.0,
                      height: 42.0,
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  UserBalance(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
