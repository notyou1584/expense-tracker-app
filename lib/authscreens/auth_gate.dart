import 'package:demo222/authscreens/auth_remote.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  Future<void> verifyPhone() async {
    String phoneNumber = "+91" + _phoneNumberController.text;

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (authResult) async {
          print('Phone number automatically verified: $authResult');
          // Check if the user is already signed in

          User? currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            // Redirect to home screen or perform necessary actions
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        verificationFailed: (authException) {
          // Display error message
          print('Phone verification failed: ${authException.message}');
        },
        codeSent: (verId, [forceResend]) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CodeVerificationScreen(verificationId: verId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (verId) {
          print('Auto retrieval timeout. Verification ID: $verId');
        },
      );
    } catch (e) {
      // Handle exceptions
      print('Exception occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Image(
            image: AssetImage('Images/Expense-o.jpg'),
            height: 200,
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Enter Phone Number',
                prefixText: '+91 ',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              verifyPhone();
            },
            child: Text('Verify Phone Number'),
          ),
        ],
      ),
    );
  }
}

class CodeVerificationScreen extends StatefulWidget {
  final String verificationId;

  CodeVerificationScreen({required this.verificationId});

  @override
  _CodeVerificationScreenState createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  final TextEditingController _verificationCodeController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense-O'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _verificationCodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Verification Code',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String smsCode = _verificationCodeController.text;
                  //signInWithPhoneNumber(widget.verificationId, smsCode);
                  signInAndSignUp(widget.verificationId, smsCode, context);
                },
                child: Text('Verify Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
