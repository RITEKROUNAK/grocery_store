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
import 'package:ecommerce_store_admin/providers/user_data_provider.dart';
import 'package:ecommerce_store_admin/repositories/base_repository.dart';

class UserDataRepository extends BaseRepository {
  UserDataProvider userDataProvider = UserDataProvider();

  @override
  void dispose() {}

  Stream<List<Order>> getNewOrders() => userDataProvider.getNewOrders();

  Future<List<Order>> getProcessedOrders() =>
      userDataProvider.getProcessedOrders();

  Future<List<Order>> getOutForDeliveryOrders() =>
      userDataProvider.getOutForDeliveryOrders();

  Future<List<Order>> getDeliveredOrders() =>
      userDataProvider.getDeliveredOrders();

  Future<List<Order>> getCancelledOrders() =>
      userDataProvider.getCancelledOrders();

  Future<List<Order>> getPendingRefundOrders() =>
      userDataProvider.getPendingRefundOrders();

  Future<List<Order>> updateNewOrders(List<Order> allOrders) =>
      userDataProvider.updateNewOrders(allOrders);

  Stream<OrderAnalytics> getOrderAnalytics() =>
      userDataProvider.getOrderAnalytics();

  Future<List<Product>> getAllProducts() => userDataProvider.getAllProducts();

  Future<List<Product>> getActiveProducts() =>
      userDataProvider.getActiveProducts();

  Future<List<Product>> getInactiveProducts() =>
      userDataProvider.getInactiveProducts();

  Future<List<Product>> getTrendingProducts() =>
      userDataProvider.getTrendingProducts();

  Future<List<Product>> getFeaturedProducts() =>
      userDataProvider.getFeaturedProducts();

  Stream<List<Product>> getLowInventoryProducts() =>
      userDataProvider.getLowInventoryProducts();

  Future<bool> updateLowInventoryProduct(String id, int quantity) =>
      userDataProvider.updateLowInventoryProduct(id, quantity);

  Future<List<Category>> getAllCategories() =>
      userDataProvider.getAllCategories();

  Stream<ProductAnalytics> getProductAnalytics() =>
      userDataProvider.getProductAnalytics();

  Stream<InventoryAnalytics> getInventoryAnalytics() =>
      userDataProvider.getInventoryAnalytics();

  Stream<MessageAnalytics> getMessageAnalytics() =>
      userDataProvider.getMessageAnalytics();

  Stream<UserAnalytics> getUserAnalytics() =>
      userDataProvider.getUserAnalytics();

  Future<List<Product>> getAllMessages() => userDataProvider.getAllMessages();

  Future<List<Product>> getNewMessages() => userDataProvider.getNewMessages();

  Future<bool> addNewProduct(Map<dynamic, dynamic> product) =>
      userDataProvider.addNewProduct(product);

  Future<bool> editProduct(Map<dynamic, dynamic> product) =>
      userDataProvider.editProduct(product);

  Future<bool> addNewCategory(Map<dynamic, dynamic> category) =>
      userDataProvider.addNewCategory(category);

  Future<bool> editCategory(Map<dynamic, dynamic> category) =>
      userDataProvider.editCategory(category);

  Future<bool> postAnswer(String id, String ans, String queId) =>
      userDataProvider.postAnswer(id, ans, queId);

  Future<bool> deleteProduct(String id) => userDataProvider.deleteProduct(id);

  Future<bool> deleteCategory(String categoryId) =>
      userDataProvider.deleteCategory(categoryId);

  Future<List<GroceryUser>> getAllUsers() => userDataProvider.getAllUsers();

  Future<List<GroceryUser>> getActiveUsers() =>
      userDataProvider.getActiveUsers();

  Future<List<GroceryUser>> getInactiveUsers() =>
      userDataProvider.getInactiveUsers();

  Future<List<GroceryUser>> getBlockedUsers() =>
      userDataProvider.getBlockedUsers();

  Stream<List<UserReport>> getUserReports() =>
      userDataProvider.getUserReports();

  Future<Product> getUserReportProduct(String id) =>
      userDataProvider.getUserReportProduct(id);

  Future<List<Order>> getUsersOrder(List<dynamic> orderIds) =>
      userDataProvider.getUsersOrder(orderIds);

  Future<Admin> getMyAccountDetails() => userDataProvider.getMyAccountDetails();

  Future<bool> blockUser(String uid) => userDataProvider.blockUser(uid);

  Future<bool> unblockUser(String uid) => userDataProvider.unblockUser(uid);

  Future<bool> proceedInitialSetup(Map map) =>
      userDataProvider.proceedInitialSetup(map);

  Future<bool> checkIfNewAdmin(String uid) =>
      userDataProvider.checkIfNewAdmin(uid);

  Future<bool> checkIfInitialSetupDone() =>
      userDataProvider.checkIfInitialSetupDone();

  Future<List<Admin>> getAllAdmins() => userDataProvider.getAllAdmins();

  Future<bool> updateAdminDetails(Map adminMap) =>
      userDataProvider.updateAdminDetails(adminMap);

  Future<Map> getAllBanners() => userDataProvider.getAllBanners();

  Future<bool> updateBanners(Map bannersMap) =>
      userDataProvider.updateBanners(bannersMap);

  Future<bool> addNewDeliveryUser(Map deliveryUserMap) =>
      userDataProvider.addNewDeliveryUser(deliveryUserMap);

  Future<bool> editDeliveryUser(Map deliveryUserMap) =>
      userDataProvider.editDeliveryUser(deliveryUserMap);

  Stream<DeliveryUserAnalytics> getDeliveryUserAnalytics() =>
      userDataProvider.getDeliveryUserAnalytics();

  Future<List<DeliveryUser>> getActivatedDeliveryUsers() =>
      userDataProvider.getActivatedDeliveryUsers();

  Future<List<DeliveryUser>> getDeactivatedDeliveryUsers() =>
      userDataProvider.getDeactivatedDeliveryUsers();

  Future<List<DeliveryUser>> getActiveDeliveryUsers() =>
      userDataProvider.getActiveDeliveryUsers();

  Future<List<DeliveryUser>> getInactiveDeliveryUsers() =>
      userDataProvider.getInactiveDeliveryUsers();

  Future<List<DeliveryUser>> getAllDeliveryUsers() =>
      userDataProvider.getAllDeliveryUsers();

  Future<List<DeliveryUser>> getReadyDeliveryUsers() =>
      userDataProvider.getReadyDeliveryUsers();

  Future<bool> activateDeliveryUser(String uid) =>
      userDataProvider.activateDeliveryUser(uid);

  Future<bool> deactivateDeliveryUser(String uid) =>
      userDataProvider.deactivateDeliveryUser(uid);

  Future<bool> proceedOrder(Map proceedOrderMap) =>
      userDataProvider.proceedOrder(proceedOrderMap);

  Future<bool> cancelOrder(Map cancelOrderMap) =>
      userDataProvider.cancelOrder(cancelOrderMap);

  Future<bool> initiateRefund(Map initiateRefundMap) =>
      userDataProvider.initiateRefund(initiateRefundMap);

  Future<bool> addNewAdmin(Map adminMap) =>
      userDataProvider.addNewAdmin(adminMap);

  Future<bool> activateAdmin(String uid) => userDataProvider.activateAdmin(uid);

  Future<bool> deactivateAdmin(String uid) =>
      userDataProvider.deactivateAdmin(uid);

  //notifications
  Stream<SellerNotification> getNotifications() =>
      userDataProvider.getNotifications();

  Future<void> markNotificationRead() =>
      userDataProvider.markNotificationRead();

  //mange cart
  Future<CartInfo> getCartInfo() => userDataProvider.getCartInfo();
  Future<bool> updateCartInfo(Map map) => userDataProvider.updateCartInfo(map);

  //payment method settings
  Future<PaymentMethods> getPaymentMethods() =>
      userDataProvider.getPaymentMethods();
  Future<bool> updatePaymentMethods(Map map) =>
      userDataProvider.updatePaymentMethods(map);
}
