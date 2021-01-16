import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_store_delivery/config/paths.dart';
import 'package:grocery_store_delivery/models/user.dart';

import 'base_provider.dart';

class AuthenticationProvider extends BaseAuthenticationProvider {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void dispose() {}

  @override
  Future<User> getCurrentUser() async {
    return firebaseAuth.currentUser;
  }

  @override
  Future<String> signInWithEmail(String email, String password) async {
    try {
      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (authResult.user != null) {
        User user = firebaseAuth.currentUser;

        DocumentSnapshot snapshot =
            await db.collection(Paths.deliveryUsersPath).doc(user.uid).get();

        if (snapshot.exists) {
          if (!snapshot.data()['activated']) {
            await firebaseAuth.signOut();
            return 'Your account has been deactivated';
          } else {
            return '';
          }
        } else {
          await firebaseAuth.signOut();
          return 'Account does not exist';
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<String> checkIfSignedIn() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      //check if blocked
      DocumentSnapshot snapshot =
          await db.collection(Paths.deliveryUsersPath).doc(user.uid).get();

      if (snapshot.exists) {
        if (!snapshot.data()['activated']) {
          await firebaseAuth.signOut();
          return 'Your account has been deactivated';
        } else {
          return '';
        }
      } else {
        await firebaseAuth.signOut();
        return 'Account does not exist';
      }
    } else {
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      Future.wait([
        firebaseAuth.signOut(),
      ]);

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> changePassword(DeliveryUser user) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: user.email);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
