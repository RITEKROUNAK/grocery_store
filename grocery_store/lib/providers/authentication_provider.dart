import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/providers/base_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationProvider extends BaseAuthenticationProvider {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String _verificationCode = '';
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void dispose() {}

  @override
  Future<User> getCurrentUser() async {
    return firebaseAuth.currentUser;
  }

  @override
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount account = await googleSignIn.signIn();
    final GoogleSignInAuthentication authentication =
        await account.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken,
    );

    await firebaseAuth.signInWithCredential(authCredential);

    User user = firebaseAuth.currentUser;

    DocumentSnapshot snapshot =
        await db.collection(Paths.usersPath).doc(user.uid).get();

    if (snapshot.exists) {
      if (snapshot.data()['isBlocked']) {
        await googleSignIn.signOut();
        await firebaseAuth.signOut();
        return 'Your account has been blocked';
      }
    } else {
      await googleSignIn.signOut();
      await firebaseAuth.signOut();
      return 'Account does not exist';
    }

    return '';
  }

  @override
  Future<User> signUpWithGoogle() async {
    final GoogleSignInAccount account = await googleSignIn.signIn();
    final GoogleSignInAuthentication authentication =
        await account.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken,
    );

    await firebaseAuth.signInWithCredential(authCredential);

    return firebaseAuth.currentUser;
  }

  @override
  Future<bool> signOutUser() async {
    try {
      Future.wait([
        firebaseAuth.signOut(),
        googleSignIn.signOut(),
      ]);

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> isLoggedIn() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      //check if blocked
      DocumentSnapshot snapshot =
          await db.collection(Paths.usersPath).doc(user.uid).get();

      if (snapshot.exists) {
        if (snapshot.data()['isBlocked']) {
          await googleSignIn.signOut();
          await firebaseAuth.signOut();
          return 'Your account has been blocked';
        } else {
          return '';
        }
      } else {
        await googleSignIn.signOut();
        await firebaseAuth.signOut();
        return 'Account does not exist';
      }
    } else {
      return null;
    }
  }

  @override
  Future<bool> signInWithMobileNo(String mobileNo) async {
    try {
      int forceResendToken;

      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: mobileNo,
        timeout: Duration(seconds: 60),
        verificationCompleted: (authCredential) =>
            phoneVerificationCompleted(authCredential),
        verificationFailed: (authException) =>
            phoneVerificationFailed(authException),
        codeSent: (verificationId, [code]) =>
            phoneCodeSent(verificationId, [code]),
        codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout,
        forceResendingToken: forceResendToken,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  phoneVerificationCompleted(AuthCredential authCredential) {
    print('verified');
  }

  phoneVerificationFailed(FirebaseException authException) {
    print('failed');
    print('Message: ${authException.message}');
    print('Code: ${authException.code}');
  }

  phoneCodeAutoRetrievalTimeout(String verificationCode) {
    this._verificationCode = verificationCode;
  }

  phoneCodeSent(String verificationCode, List<int> code) {
    this._verificationCode = verificationCode;
  }

  @override
  Future<User> signInWithSmsCode(String smsCode) async {
    try {
      AuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: _verificationCode, smsCode: smsCode);
      UserCredential authResult =
          await firebaseAuth.signInWithCredential(authCredential);
      if (authResult.user != null) {
        print('');
        print('PHONE AUTH UID :: ' + authResult.user.uid);
        print('PHONE AUTH CREDENTIALS :: ' + authCredential.toString());
        print('');
        return authResult.user;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<String> checkIfBlocked(String mobileNo) async {
    try {
      //check if blocked
      QuerySnapshot snapshot = await db
          .collection(Paths.usersPath)
          .where('mobileNo', isEqualTo: mobileNo)
          .get();

      if (snapshot.size > 0) {
        for (var item in snapshot.docs) {
          if (item.data()['isBlocked']) {
            return 'Your account has been blocked';
          }
        }
      } else {
        return 'Account does not exist';
      }
      return '';
    } catch (e) {
      print(e);
      return null;
    }
  }
}
