import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'const.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final Function(bool) passIsLoading;
  final Function(String) passVerificationID;
  final Function(String) sendErrorMessage;

  PhoneVerificationScreen(
      this.passIsLoading, this.passVerificationID, this.sendErrorMessage);

  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  late String phoneNumber;
  //late String otp;
  String errorMessage = "";
  final _auth = FirebaseAuth.instance;
  String verificationID = "";

  String formatPhoneNumber(origNum) {
    origNum = origNum.replaceAll(" ", "");
    origNum = origNum.replaceAll("-", "");
    origNum = origNum.replaceAll("(", "");
    origNum = origNum.replaceAll(")", "");
    origNum = origNum.replaceAll(".", "");

    if (!origNum.contains("+1")) {
      origNum = "+1" + origNum;
    }
    return origNum;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.center,
            onChanged: (value) {
              phoneNumber = value;
            },
            decoration: inputStyle.copyWith(
              hintText: 'Enter your phone number',
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
                widget.passIsLoading(true);

                phoneNumber = formatPhoneNumber(phoneNumber);

                _auth.verifyPhoneNumber(
                  phoneNumber: phoneNumber,
                  verificationCompleted: (cred) async {},
                  verificationFailed: (failOBJ) async {
                    widget.passIsLoading(false);
                    widget.sendErrorMessage('verification failed');
                  },
                  codeSent: (id, resentingToken) async {
                    widget.passIsLoading(false);
                    verificationID = id;
                    widget.passVerificationID(id);
                    widget.sendErrorMessage('');
                  },
                  codeAutoRetrievalTimeout: (verificationID) async {},
                );
              },
              minWidth: 300.0,
              height: 42.0,
              child: Text(
                'Verify Phone Number',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
