import 'dart:io';

import 'package:grocery_store/models/banner.dart';
import 'package:grocery_store/models/card.dart';
import 'package:grocery_store/models/cart.dart';
import 'package:grocery_store/models/cart_info.dart';
import 'package:grocery_store/models/cart_values.dart';
import 'package:grocery_store/models/category.dart';
import 'package:grocery_store/models/my_order.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/models/user_notification.dart';
import 'package:grocery_store/providers/user_data_provider.dart';
import 'package:grocery_store/repositories/base_repository.dart';

class UserDataRepository extends BaseRepository {
  UserDataProvider userDataProvider = UserDataProvider();

  Future<GroceryUser> getUser(String uid) => userDataProvider.getUser(uid);

  Future<GroceryUser> getUserByMobileNo(String mobileNo) =>
      userDataProvider.getUserByMobileNo(mobileNo);

  Future<GroceryUser> saveUserDetails(
    String uid,
    String name,
    String email,
    String mobileNo,
    String profileImageUrl,
    String tokenId,
    List<Address> address,
    List wishlist,
    String loggedInVia,
  ) =>
      userDataProvider.saveUserDetails(
        address: address,
        email: email,
        mobileNo: mobileNo,
        name: name,
        profileImageUrl: profileImageUrl,
        tokenId: tokenId,
        uid: uid,
        wishlist: wishlist,
        loggedInVia: loggedInVia,
      );

  Future<List<Category>> getCategories() =>
      userDataProvider.getCategoriesList();

  Future<Banner> getBanners() => userDataProvider.getBanners();

  Future<List<Product>> getBannerAllProducts(String category) =>
      userDataProvider.getBannerAllProducts(category);

  Future<Product> getProduct(String id) => userDataProvider.getProduct(id);

  Future<List<Product>> getTrendingProducts() =>
      userDataProvider.getTrendingProducts();

  Future<List<Product>> getFeaturedProducts() =>
      userDataProvider.getFeaturedProducts();

  Future<List<Product>> getSimilarProducts({
    String category,
    String subCategory,
    String productId,
  }) =>
      userDataProvider.getSimilarProducts(category, subCategory, productId);

  Future<List<Product>> getCategoryProducts({
    String category,
  }) =>
      userDataProvider.getCategoryProducts(category);

  Future<bool> addToCart(String productId, String uid) =>
      userDataProvider.addToCart(productId, uid);

  Future<bool> removeFromCart(String productId, String uid) =>
      userDataProvider.removeFromCart(productId, uid);

  Future<CartValues> getCartValues() => userDataProvider.getCartValues();

  Stream<int> getCartCount(String uid) => userDataProvider.getCartCount(uid);

  Stream<UserNotification> getNotifications(String uid) =>
      userDataProvider.getNotifications(uid);

  Future<List<Cart>> getCartProducts(String uid) =>
      userDataProvider.getCartProducts(uid);

  Future<bool> increaseQuantity(
          String quantity, String uid, String productId) =>
      userDataProvider.increaseQuantity(quantity, uid, productId);

  Future<bool> decreaseQuantity(
          String quantity, String uid, String productId) =>
      userDataProvider.decreaseQuantity(quantity, uid, productId);

  Future<List<Product>> getWishlistProducts(String uid) =>
      userDataProvider.getWishlistProducts(uid);

  Future<bool> addToWishlist(String productId, String uid) =>
      userDataProvider.addToWishlist(productId, uid);

  Future<bool> removeFromWishlist(String productId, String uid) =>
      userDataProvider.removeFromWishlist(productId, uid);

  Future<List<Product>> getFirstSearch(String searchWord) =>
      userDataProvider.getFirstSearch(searchWord);

  List<Product> getNewSearch(String searchWord, List<Product> productsList) =>
      userDataProvider.getNewSearch(searchWord, productsList);

  Future<bool> addCard(Map<String, dynamic> card) =>
      userDataProvider.addCard(card);

  Future<bool> editCard(Map<String, dynamic> card, int index) =>
      userDataProvider.editCard(card, index);

  Future<List> getAllCards() => userDataProvider.getAllCards();

  Future<bool> placeOrder(
    int paymentMethod,
    String uid,
    List<Cart> cartList,
    String orderAmt,
    String shippingAmt,
    String discountAmt,
    String totalAmt,
    String taxAmt, {
    Card card,
    String razorpayTxnId,
  }) =>
      userDataProvider.placeOrder(
        paymentMethod,
        uid,
        cartList,
        orderAmt,
        shippingAmt,
        discountAmt,
        totalAmt,
        taxAmt,
        card: card,
        razorpayTxnId: razorpayTxnId,
      );

  Future<List> getAllOrders(String uid) => userDataProvider.getAllOrders(uid);

  Future<List> getCancelledOrders(List<MyOrder> allOrders) =>
      userDataProvider.getCancelledOrders(allOrders);

  Future<List> getDeliveredOrders(List<MyOrder> allOrders) =>
      userDataProvider.getDeliveredOrders(allOrders);

  Future<bool> cancelOrder(Map cancelOrderMap) =>
      userDataProvider.cancelOrder(cancelOrderMap);

  Future<GroceryUser> getAccountDetails(String uid) =>
      userDataProvider.getAccountDetails(uid);

  Future<bool> addAddress(
          String uid, List<Address> address, int defaultAddress) =>
      userDataProvider.addAddress(uid, address, defaultAddress);

  Future<bool> removeAddress(
          String uid, List<Address> address, bool isDefault) =>
      userDataProvider.removeAddress(uid, address, isDefault);

  Future<bool> editAddress(
          String uid, List<Address> address, int defaultAddress) =>
      userDataProvider.editAddress(uid, address, defaultAddress);

  Future<bool> updateAccountDetails(GroceryUser user, File profileImage) =>
      userDataProvider.updateAccountDetails(user, profileImage);

  Future<bool> postQuestion(String uid, String productId, String question) =>
      userDataProvider.postQuestion(uid, productId, question);

  Future<Map<dynamic, dynamic>> checkRateProduct(
          String uid, String productId, Product product) =>
      userDataProvider.checkRateProduct(uid, productId, product);

  Future<bool> rateProduct(String uid, String productId, String rating,
          String review, String result, Product product) =>
      userDataProvider.rateProduct(
          uid, productId, rating, review, result, product);

  Future<bool> incrementView(String productId) =>
      userDataProvider.incrementView(productId);

  Future<void> markNotificationRead(String uid) =>
      userDataProvider.markNotificationRead(uid);

  Future<bool> reportProduct(
          String uid, String productId, String reportDescription) =>
      userDataProvider.reportProduct(uid, productId, reportDescription);

  @override
  void dispose() {
    userDataProvider.dispose();
  }
}
