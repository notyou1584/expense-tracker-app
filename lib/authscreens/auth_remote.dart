import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<UserCredential?> signInWithPhoneNumber(
  String verificationId,
  String smsCode,
) async {
  try {
    AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return (await FirebaseAuth.instance.signInWithCredential(credential));
  } catch (e) {
    print('Failed to verify phone number: $e');
  }
  return null;
}

void signInAndSignUp(String verificationId, String smsCode) async {
  try {
    final cred = await signInWithPhoneNumber(verificationId, smsCode);
    final user = cred!.user;
    String firebaseId = user!.uid;
    String? phoneNumber = user.phoneNumber;

    // After successful sign-in, proceed with user signup
    final Map<String, dynamic> signupResult = await userSignup(
        '5505', // Access key
        firebaseId, // Firebase user ID
        phoneNumber!,
        '1',
        '1' // User's phone number
        );

    if (signupResult['success']) {
      print('User signed up successfully');
      print(signupResult['data']); // Access user data here+DS
      // Navigate to next screen or perform necessary actions
    } else {
      print('Error: ${signupResult['message']}');
      // Handle error case appropriately
    }
  } catch (e) {
    print('Failed to sign in and sign up: $e');
    // Handle error case appropriately
  }
}

Future<Map<String, dynamic>> userSignup(String accessKey, String firebaseId,
    String mobile, String usersignup, String status) async {
  final String apiUrl = '00';

  final Map<String, String> postData = {
    'access_key': accessKey,
    'user_signup': usersignup,
    'firebase_id': firebaseId,
    'mobile': mobile,
    'status': status // Assuming status is always 1 for active users
  };

  final http.Response response =
      await http.post(Uri.parse(apiUrl), body: postData);

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (responseData['error'] == 'false') {
      return {
        'success': true,
        'message': responseData['message'],
        'data': responseData['data'],
      };
    } else {
      return {
        'success': false,
        'message': responseData['message'],
      };
    }
  } else {
    return {
      'success': false,
      'message': 'Failed to connect to server',
    };
  }
}
