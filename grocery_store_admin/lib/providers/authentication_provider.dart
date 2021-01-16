import 'package:ecommerce_store_admin/providers/base_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationProvider extends BaseAuthenticationProvider {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void dispose() {}

  @override
  Future<bool> checkIfSignedIn() async {
    final user = firebaseAuth.currentUser;
    return user != null;
  }

  @override
  Future<User> getCurrentUser() async {
    return firebaseAuth.currentUser;
  }

  @override
  Future<bool> signOutUser() async {
    try {
      Future.wait([
        firebaseAuth.signOut(),
        // googleSignIn.signOut(),
      ]);

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<User> signInWithEmail(String email, String password) async {
    try {
      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (authResult.user != null) {
        return authResult.user;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
