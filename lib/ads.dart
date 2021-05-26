import 'package:payday/login.dart';
import 'package:payday/shared/balanceDisplay.dart';
import 'package:payday/shared/bannerWidget.dart';
import 'package:payday/shared/pay_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsScreen extends StatefulWidget {
  static String id = 'Ads_Screen';

  @override
  _AdsScreenState createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  final _auth = FirebaseAuth.instance;
  String userID = '';

  void initState() {
    super.initState();
    User? currentUser = _auth.currentUser;
    userID = currentUser!.uid;
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
        child: PayDrawer('ads'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BannerWidget(AdSize.mediumRectangle, userID),
            SizedBox(
              height: 100,
            ),
            UserBalance(),
          ],
        ),
      ),
    );
  }
}
