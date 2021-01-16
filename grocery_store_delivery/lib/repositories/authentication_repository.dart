import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_store_delivery/models/user.dart';
import 'package:grocery_store_delivery/providers/authentication_provider.dart';
import 'package:grocery_store_delivery/providers/base_provider.dart';

import 'base_repository.dart';

class AuthenticationRepository extends BaseRepository {
  BaseAuthenticationProvider authenticationProvider = AuthenticationProvider();

  @override
  void dispose() {
    authenticationProvider.dispose();
  }

  Future<User> getCurrentUser() =>
      authenticationProvider.getCurrentUser();

  Future<String> signInWithEmail(String email, String password) =>
      authenticationProvider.signInWithEmail(email, password);

  Future<String> checkIfSignedIn() => authenticationProvider.checkIfSignedIn();

  Future<bool> signOut() => authenticationProvider.signOut();

  Future<bool> changePassword(DeliveryUser user) => authenticationProvider.changePassword(user);
}
