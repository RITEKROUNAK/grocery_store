import 'dart:io';

import 'package:grocery_store/models/banner.dart';
import 'package:grocery_store/models/cart.dart';
import 'package:grocery_store/models/cart_info.dart';
import 'package:grocery_store/models/cart_values.dart';
import 'package:grocery_store/models/category.dart';
import 'package:grocery_store/models/my_order.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/models/user_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseProvider {
  void dispose();
}

abstract class BaseAuthenticationProvider extends BaseProvider {
  Future<String> isLoggedIn();
  Future<String> signInWithGoogle();
  Future<User> signUpWithGoogle();
  Future<bool> signInWithMobileNo(String mobileNo);
  Future<String> checkIfBlocked(String mobileNo);
  Future<User> signInWithSmsCode(String smsCode);
  Future<bool> signOutUser();
  Future<User> getCurrentUser();
}

abstract class BaseUserDataProvider extends BaseProvider {
  Future<GroceryUser> getUser(String uid);
  Future<GroceryUser> getUserByMobileNo(String mobileNo);
  Future<GroceryUser> saveUserDetails({
    String uid,
    String name,
    String email,
    String mobileNo,
    String profileImageUrl,
    String tokenId,
    List<Address> address,
    List wishlist,
    String loggedInVia,
  });
  Future<List<Category>> getCategoriesList();
  Future<Banner> getBanners();
  Future<List<Product>> getBannerAllProducts(String category);
  Future<Product> getProduct(String id);
  Future<List<Product>> getTrendingProducts();
  Future<List<Product>> getFeaturedProducts();
  Future<List<Product>> getSimilarProducts(
    String category,
    String subCategory,
    String productId,
  );
  Future<List<Product>> getCategoryProducts(
    String category,
  );
  Future<bool> addToCart(String productId, String uid);
  Future<bool> removeFromCart(String productId, String uid);
  Future<CartValues> getCartValues();
  Future<List<Cart>> getCartProducts(String uid);
  Stream<int> getCartCount(String uid);
  Future<bool> increaseQuantity(String quantity, String uid, String productId);
  Future<bool> decreaseQuantity(String quantity, String uid, String productId);
  Future<List<Product>> getWishlistProducts(String uid);
  Future<List<Product>> getFirstSearch(String searchWord);
  List<Product> getNewSearch(String searchWord, List<Product> productsList);
  Future<bool> addToWishlist(String productId, String uid);
  Future<bool> removeFromWishlist(String productId, String uid);
  Future<bool> addCard(Map<String, dynamic> card);
  Future<bool> editCard(Map<String, dynamic> card, int index);
  Future<List> getAllCards();
  Future<bool> placeOrder(
    int paymentMethod,
    String uid,
    List<Cart> cartList,
    String orderAmt,
    String shippingAmt,
    String discountAmt,
    String totalAmt,
    String taxAmt,
  );
  Future<List> getAllOrders(String uid);
  Future<List> getDeliveredOrders(List<MyOrder> allOrders);
  Future<List> getCancelledOrders(List<MyOrder> allOrders);
  Future<bool> cancelOrder(Map cancelOrderMap);
  Future<GroceryUser> getAccountDetails(String uid);
  Future<bool> addAddress(
      String uid, List<Address> address, int defaultAddress);
  Future<bool> removeAddress(String uid, List<Address> address, bool isDefault);
  Future<bool> editAddress(
      String uid, List<Address> address, int defaultAddress);
  Future<bool> updateAccountDetails(GroceryUser user, File profileImage);
  Future<bool> postQuestion(String uid, String productId, String question);
  Future<Map<dynamic, dynamic>> checkRateProduct(
    String uid,
    String productId,
    Product product,
  );
  Future<bool> rateProduct(
    String uid,
    String productId,
    String rating,
    String review,
    String result,
    Product product,
  );
  Future<bool> incrementView(String productId);
  Stream<UserNotification> getNotifications(String uid);
  Future<void> markNotificationRead(String uid);
  Future<bool> reportProduct(
      String uid, String productId, String reportDescription);
}

abstract class BaseStorageProvider extends BaseProvider {}
