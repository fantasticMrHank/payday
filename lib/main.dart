import 'package:payday/ads.dart';
import 'package:payday/login.dart';
import 'package:payday/pay.dart';
import 'package:payday/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // prevents device rotation
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  await Firebase.initializeApp();

  runApp(BonfirePays());
}

class BonfirePays extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? AdsScreen.id
          : LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        AdsScreen.id: (context) => AdsScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        PayScreen.id: (context) => PayScreen(),
      },
    );
  }
}
