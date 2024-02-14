import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<UserCredential?> signInWithPhoneNumber(
  String verificationId,
  String smsCode,
) async {
  try {
    // Check if the user is already signed in
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Retrieve the user's current authentication provider data
      List<UserInfo> providerData = currentUser.providerData;

      // Extract the provider ID from the first provider in the list
      String providerId =
          providerData.isNotEmpty ? providerData[0].providerId : '';

      // Create a new AuthCredential object based on the provider ID
      AuthCredential credential;
      if (providerId == 'phone') {
        // If the user is already authenticated via phone, create PhoneAuthCredential
        credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);
      } else {
        // Handle other authentication providers here if needed
        throw Exception('Unsupported authentication provider: $providerId');
      }

      // Sign in with the credential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }

    // If the user is not signed in, proceed with phone authentication
    AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    // Sign in with the credential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    if (e is FormatException) {
      print('Invalid format: $e');
    } else {
      print('Failed to verify phone number: $e');
    }
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
  final String apiUrl = 'http://192.168.1.121:80/Expense-o/apis.php';

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
    print(response.body);
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);

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
