import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'const.dart';

class CodeScreen extends StatefulWidget {
  final String verificationID;
  final Function(PhoneAuthCredential) signIn;

  CodeScreen(this.verificationID, this.signIn);

  @override
  _CodeScreenState createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  late String otp;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            onChanged: (value) {
              otp = value;
            },
            decoration: inputStyle.copyWith(
              hintText: 'Enter the verification code',
            ),
          ),
          SizedBox(
            height: 20,
          ),

          SizedBox(
            height: 10,
          ),
          // send OTP
          Material(
            color: Colors.amber,
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            elevation: 5.0,
            child: MaterialButton(
              onPressed: () async {
                PhoneAuthCredential cred = PhoneAuthProvider.credential(
                    verificationId: widget.verificationID, smsCode: otp);
                widget.signIn(cred);
              },
              minWidth: 300.0,
              height: 42.0,
              child: Text(
                'Send Code',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
