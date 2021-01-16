import 'package:ecommerce_store_admin/providers/authentication_provider.dart';
import 'package:ecommerce_store_admin/providers/base_provider.dart';
import 'package:ecommerce_store_admin/repositories/base_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository extends BaseRepository {
  BaseAuthenticationProvider authenticationProvider = AuthenticationProvider();

  @override
  void dispose() {
    authenticationProvider.dispose();
  }

  Future<bool> signOutUser() => authenticationProvider.signOutUser();

  Future<bool> checkIfSignedIn() => authenticationProvider.checkIfSignedIn();

  Future<User> getCurrentUser() =>
      authenticationProvider.getCurrentUser();

  Future<User> signInWithEmail(String email, String password) =>
      authenticationProvider.signInWithEmail(email, password);
}
