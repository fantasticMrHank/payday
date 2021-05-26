import 'package:payday/ads.dart';
import 'package:payday/profile.dart';
import 'package:payday/shared/codecreen.dart';
import 'package:payday/shared/phoneVerificationScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'Login_Screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void checkSignInStatus() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);

        Navigator.popAndPushNamed(
          context,
          AdsScreen.id,
        );
      }
    });
  }

  void initState() {
    super.initState();
    checkSignInStatus();
  }

  bool isLoading = false;

  late String phoneNumber;
  late String otp;
  String errorMessage = "";
  final _auth = FirebaseAuth.instance;
  String verificationID = "";

  String currentScreen = 'phoneScreen';

  int trialTimes = 0;

  void signInWithCred(PhoneAuthCredential cred) async {
    setState(() {
      isLoading = true;
    });
    final authCred =
        await _auth.signInWithCredential(cred).catchError((onError) {
      trialTimes++;
      setState(() {
        isLoading = false;
      });
      errorMessage = "incorrect code";
      if (trialTimes > 3) {
        setState(() {
          currentScreen = 'phoneScreen';
          trialTimes = 0;
        });
      }
    });

    setState(() {
      isLoading = false;
    });

    if (authCred.user != null) {
      Navigator.popAndPushNamed(context, ProfileScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: SpinKitFadingCircle(
              color: Colors.amber,
              size: 50.0,
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Image(
                          image: AssetImage('images/bonfire_500.png'),
                          width: 150,
                          height: 150,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        (currentScreen == 'phoneScreen')
                            ? PhoneVerificationScreen(
                                // check IsLoading
                                (val) {
                                setState(() {
                                  isLoading = val;
                                });
                              },
                                // get the verification ID
                                (id) {
                                verificationID = id;
                                print("verification id: " + verificationID);
                                setState(() {
                                  currentScreen = 'codeScreen';
                                });
                              },
                                // error message
                                (message) {
                                errorMessage = message;
                              })
                            : CodeScreen(verificationID, (cred) {
                                signInWithCred(cred);
                              }),
                        Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
