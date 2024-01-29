import 'package:demo222/utils/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  Future<void> verifyPhone(String phoneNumber) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      print('Phone number automatically verified: $authResult');
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print('Phone verification failed: ${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int? forceResend]) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CodeVerificationScreen(verificationId: verId),
        ),
      );
    };

    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      print('Auto retrieval timeout. Verification ID: $verId');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verified,
      verificationFailed: verificationFailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                verifyPhone(_phoneNumberController.text);
              },
              child: Text('Verify Phone Number'),
            ),
          ],
        ),
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
  final TextEditingController _smsCodeController = TextEditingController();

  Future<void> signInWithPhoneNumber(
      String verificationId, String smsCode) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      print('Phone number verified and signed in successfully.');
    } catch (e) {
      print('Failed to verify phone number: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _smsCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'SMS Code',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                signInWithPhoneNumber(
                    widget.verificationId, _smsCodeController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExpenseTrackerHomeScreen()),
                );
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
