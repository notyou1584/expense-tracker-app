import 'package:demo222/authscreens/auth_remote.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  String _selectedCountryCode = "+91";

  Future<void> verifyPhone() async {
    String phoneNumber = _selectedCountryCode + _phoneNumberController.text;
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: _selectedCountryCode,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCountryCode = newValue!;
                    });
                  },
                  items: <String>[
                    '+1',
                    '+91',
                    '+44',
                    '+61'
                  ] // Example country codes
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Enter Phone Number',
                      ),
                    ),
                  ),
                ),
              ],
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
  List<TextEditingController> _controllers = [];
  List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((node) => node.dispose());
    super.dispose();
  }

  void _initializeControllers() {
    for (int i = 0; i < 6; i++) {
      TextEditingController controller = TextEditingController();
      FocusNode focusNode = FocusNode();
      _controllers.add(controller);
      _focusNodes.add(focusNode);
      controller.addListener(() {
        if (controller.text.isNotEmpty && i < 5) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }
  }

  

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => _buildCodeBox(index),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String smsCode =
                      _controllers.map((controller) => controller.text).join();
                  //signInWithPhoneNumber(widget.verificationId, smsCode);
                  signInAndSignUp(widget.verificationId, smsCode);

                  Navigator.pushReplacementNamed(context, '/username');
                },
                child: Text('Verify Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeBox(int index) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (String value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          }
        },
        decoration: InputDecoration(
          counter: Offstage(), // Hide character counter
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
