import 'package:grocery_store/providers/authentication_provider.dart';
import 'package:grocery_store/providers/base_provider.dart';
import 'package:grocery_store/repositories/base_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository extends BaseRepository {
  BaseAuthenticationProvider authenticationProvider = AuthenticationProvider();

  @override
  void dispose() {
    authenticationProvider.dispose();
  }

  Future<String> signInWithGoogle() =>
      authenticationProvider.signInWithGoogle();

  Future<User> signUpWithGoogle() =>
      authenticationProvider.signUpWithGoogle();

  Future<bool> signInWithMobileNo(String mobileNo) =>
      authenticationProvider.signInWithMobileNo(mobileNo);

  Future<String> checkIfBlocked(String mobileNo) =>
      authenticationProvider.checkIfBlocked(mobileNo);

  Future<User> signInWithSmsCode(String smsCode) =>
      authenticationProvider.signInWithSmsCode(smsCode);

  Future<bool> signOutUser() => authenticationProvider.signOutUser();

  Future<String> isLoggedIn() => authenticationProvider.isLoggedIn();

  Future<User> getCurrentUser() => authenticationProvider.getCurrentUser();
}
