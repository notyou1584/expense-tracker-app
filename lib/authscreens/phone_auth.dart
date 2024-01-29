import 'package:firebase_auth/firebase_auth.dart';

// Function to initiate phone authentication
Future<void> verifyPhone(String phoneNumber) async {
  final PhoneVerificationCompleted verified = (AuthCredential authResult) {
    // This callback will be invoked if the user's phone number is automatically verified.
    // You can handle the automatic verification here.
    print('Phone number automatically verified: $authResult');
  };

  final PhoneVerificationFailed verificationFailed =
      (FirebaseAuthException authException) {
    // This callback will be invoked if verification fails.
    print('Phone verification failed: ${authException.message}');
  };

  final PhoneCodeSent smsSent = (String verId, [int? forceResend]) {
    // This callback will be invoked when an SMS is sent.
    // You can save the verification id to use later.
    print('SMS sent. Verification ID: $verId');
  };

  final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
    // This callback will be invoked when the automatic SMS code retrieval
    // times out. You can handle this scenario here.
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
