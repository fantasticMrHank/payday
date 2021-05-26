import 'package:payday/profile.dart';
import 'package:payday/shared/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'Register_Screen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.popAndPushNamed(
          context,
          ProfileScreen.id,
        );
      }
    });
  }

  bool isLoading = false;
  late String email;
  late String password;
  String errorMessage = "";
  final _auth = FirebaseAuth.instance;
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
                        Text(
                          'Register Screen',
                          style: TextStyle(
                              fontSize: 20, fontStyle: FontStyle.italic),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: inputStyle.copyWith(
                            hintText: 'Enter your email',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          textAlign: TextAlign.center,
                          obscureText: true,
                          onChanged: (value) {
                            password = value;
                          },
                          decoration: inputStyle.copyWith(
                            hintText: 'Enter your password',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Material(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          elevation: 5.0,
                          child: MaterialButton(
                            onPressed: () async {
                              // show spinner
                              setState(() {
                                isLoading = true;
                              });

                              _auth
                                  .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              )
                                  // login error
                                  .catchError((onError) {
                                setState(() {
                                  isLoading = false;
                                });
                                errorMessage = onError.toString();
                              });
                            },
                            minWidth: 300.0,
                            height: 42.0,
                            child: Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            //  Navigator.popAndPushNamed(context, LoginScreen.id);
                          },
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
