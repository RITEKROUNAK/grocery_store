import 'package:ecommerce_store_admin/models/admin.dart';
import 'package:ecommerce_store_admin/models/banner.dart';
import 'package:ecommerce_store_admin/models/cart_info.dart';
import 'package:ecommerce_store_admin/models/category.dart';
import 'package:ecommerce_store_admin/models/delivery_user.dart';
import 'package:ecommerce_store_admin/models/delivery_user_analytics.dart';
import 'package:ecommerce_store_admin/models/inventory_analytics.dart';
import 'package:ecommerce_store_admin/models/message.dart';
import 'package:ecommerce_store_admin/models/message_analytics.dart';
import 'package:ecommerce_store_admin/models/order.dart';
import 'package:ecommerce_store_admin/models/order_analytics.dart';
import 'package:ecommerce_store_admin/models/payment_methods.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/models/product_analytics.dart';
import 'package:ecommerce_store_admin/models/seller_notification.dart';
import 'package:ecommerce_store_admin/models/user.dart';
import 'package:ecommerce_store_admin/models/user_analytics.dart';
import 'package:ecommerce_store_admin/models/user_report.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseProvider {
  void dispose();
}

abstract class BaseAuthenticationProvider extends BaseProvider {
  Future<bool> checkIfSignedIn();
  Future<bool> signOutUser();
  Future<User> getCurrentUser();
  Future<User> signInWithEmail(String email, String password);
}

abstract class BaseUserDataProvider extends BaseProvider {
  Stream<List<Order>> getNewOrders();

  Future<List<Order>> getProcessedOrders();

  Future<List<Order>> getOutForDeliveryOrders();

  Future<List<Order>> getDeliveredOrders();

  Future<List<Order>> getCancelledOrders();

  Future<List<Order>> getPendingRefundOrders();

  Future<List<Order>> updateNewOrders(List<Order> allOrders);

  Stream<OrderAnalytics> getOrderAnalytics();

  Future<List<Product>> getAllProducts();

  Future<List<Product>> getActiveProducts();

  Future<List<Product>> getInactiveProducts();

  Future<List<Product>> getTrendingProducts();

  Future<List<Product>> getFeaturedProducts();

  Stream<List<Product>> getLowInventoryProducts();

  Future<bool> updateLowInventoryProduct(String id, int quantity);

  Future<List<Category>> getAllCategories();

  Stream<ProductAnalytics> getProductAnalytics();

  Stream<InventoryAnalytics> getInventoryAnalytics();

  Stream<MessageAnalytics> getMessageAnalytics();

  Stream<UserAnalytics> getUserAnalytics();

  Future<List<Product>> getAllMessages();

  Future<List<Product>> getNewMessages();

  Future<bool> addNewProduct(Map<dynamic, dynamic> product);

  Future<bool> editProduct(Map<dynamic, dynamic> product);

  Future<bool> addNewCategory(Map<dynamic, dynamic> category);

  Future<bool> editCategory(Map<dynamic, dynamic> category);

  Future<bool> postAnswer(String id, String ans, String queId);

  Future<bool> deleteProduct(String id);

  Future<bool> deleteCategory(String categoryId);

  Future<List<GroceryUser>> getAllUsers();

  Future<List<GroceryUser>> getActiveUsers();

  Future<List<GroceryUser>> getInactiveUsers();

  Future<List<GroceryUser>> getBlockedUsers();

  Stream<List<UserReport>> getUserReports();

  Future<Product> getUserReportProduct(String id);

  Future<List<Order>> getUsersOrder(List<dynamic> orderIds);

  Future<Admin> getMyAccountDetails();

  Future<bool> blockUser(String uid);

  Future<bool> unblockUser(String uid);

  Future<bool> proceedInitialSetup(Map map);

  Future<bool> checkIfNewAdmin(String uid);

  Future<bool> checkIfInitialSetupDone();

  Future<bool> updateAdminDetails(Map adminMap);

  Future<List<Admin>> getAllAdmins();

  Future<Map> getAllBanners();

  Future<bool> updateBanners(Map bannersMap);

  Future<bool> addNewDeliveryUser(Map deliveryUserMap);

  Future<bool> editDeliveryUser(Map deliveryUserMap);

  Stream<DeliveryUserAnalytics> getDeliveryUserAnalytics();

  Future<List<DeliveryUser>> getActivatedDeliveryUsers();

  Future<List<DeliveryUser>> getDeactivatedDeliveryUsers();

  Future<List<DeliveryUser>> getActiveDeliveryUsers();

  Future<List<DeliveryUser>> getInactiveDeliveryUsers();

  Future<List<DeliveryUser>> getAllDeliveryUsers();

  Future<List<DeliveryUser>> getReadyDeliveryUsers();

  Future<bool> activateDeliveryUser(String uid);

  Future<bool> deactivateDeliveryUser(String uid);

  Future<bool> proceedOrder(Map proceedOrderMap);

  Future<bool> cancelOrder(Map cancelOrderMap);

  Future<bool> initiateRefund(Map initiateRefundMap);

  Future<bool> addNewAdmin(Map adminMap);

  Future<bool> activateAdmin(String uid);

  Future<bool> deactivateAdmin(String uid);

  //notifications
  Stream<SellerNotification> getNotifications();
  Future<void> markNotificationRead();

  //mange cart
  Future<CartInfo> getCartInfo();
  Future<bool> updateCartInfo(Map map);

  //payment method settings
  Future<PaymentMethods> getPaymentMethods();
  Future<bool> updatePaymentMethods(Map map);
}

abstract class BaseStorageProvider extends BaseProvider {}
