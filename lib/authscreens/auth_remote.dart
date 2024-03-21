import 'package:demo222/api_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

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

void signInAndSignUp(
    String verificationId, String smsCode, BuildContext context) async {
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
      '1', // Assuming usersignup parameter value
      '1', // Assuming status parameter value
    );
    if (signupResult['success']) {
      if (signupResult['userExists']) {
        // User already exists, navigate to home screen
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Signup was successful, navigate to next screen
        Navigator.pushReplacementNamed(context, '/username');
      }
    }
  } catch (e) {
    print('Failed to sign in and sign up: $e');
    // Handle error case appropriately
  }
}

Future<Map<String, dynamic>> userSignup(String accessKey, String firebaseId,
    String mobile, String usersignup, String status) async {
  final String apiUrl = '$apiBaseUrl/expense-o/apis.php';

  final Map<String, String> postData = {
    'access_key': accessKey,
    'user_signup': usersignup,
    'firebase_id': firebaseId,
    'mobile': mobile,
    'status': status, // Assuming status is always 1 for active users
  };

  try {
    final http.Response response =
        await http.post(Uri.parse(apiUrl), body: postData);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['error'] == true) {
        // Check if the user already exists
        if (responseData['message'] == 'User already exists') {
          return {
            'success': true,
            'message': responseData['message'],
            'userExists': true,
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'],
            'userExists': false,
          };
        }
      } else {
        return {
          'success': true,
          'message': responseData['message'],
          'userExists': false,
        };
      }
    } else {
      return {
        'success': false,
        'message': 'Failed to connect to server',
        'userExists': false,
      };
    }
  } catch (e) {
    print('Exception during user signup: $e');
    return {
      'success': false,
      'message': 'Exception during user signup: $e',
      'userExists': false,
    };
  }
}

Future<void> userdata(
    String uid, String user_name, String email, File? image) async {
  final String apiUrl = '$apiBaseUrl/expense-o/add_name.php';
  final Map<String, String> postData = {
    'add_name': '1',
    'access_key': '5505',
    'user_name': user_name,
    'user_id': uid,
    'email': email
  };

  var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

  // Add other fields to the request
  postData.forEach((key, value) {
    request.fields[key] = value;
  });

  // Add image file to the request if provided
  if (image != null) {
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        image.path,
      ),
    );
  }

  var response = await request.send();

  if (response.statusCode == 200) {
    final responseData = json.decode(await response.stream.bytesToString());
    if (responseData != null &&
        responseData['error'] != null &&
        responseData['error'] == 'false' &&
        responseData['data'] != null) {
      print('Username and email added successfully');

      // Extract user data from response
      final userData = responseData['data'];
      // Now you can use userData for further processing if needed
      print('Updated user data: $userData');
    } else {
      // Check if there's a message in the response, else print a generic error message
      final errorMessage = responseData != null
          ? responseData['message']
          : 'Unknown error occurred';
      print('Failed to add username and email: $errorMessage');
    }
  } else {
    print('Failed to add username and email: ${response.reasonPhrase}');
  }
}
