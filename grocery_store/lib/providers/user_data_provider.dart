import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_store/config/config.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/models/banner.dart';
import 'package:grocery_store/models/card.dart';
import 'package:grocery_store/models/cart.dart';
import 'package:grocery_store/models/cart_info.dart';
import 'package:grocery_store/models/cart_values.dart';
import 'package:grocery_store/models/category.dart';
import 'package:grocery_store/models/my_order.dart';
import 'package:grocery_store/models/payment_methods.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/models/user_notification.dart';
import 'package:grocery_store/providers/base_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class UserDataProvider extends BaseUserDataProvider {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  GroceryUser user;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  void dispose() {}

  @override
  Future<GroceryUser> getUser(String uid) async {
    DocumentReference docRef = db.collection(Paths.usersPath).doc(uid);
    final DocumentSnapshot documentSnapshot = await docRef.get();

    return GroceryUser.fromFirestore(documentSnapshot);
  }

  @override
  Future<GroceryUser> getUserByMobileNo(String mobileNo) async {
    CollectionReference docRef =
        db.collection(Paths.usersPath).where('mobileNo', isEqualTo: mobileNo);
    final QuerySnapshot querySnapshots = await docRef.get();
    DocumentSnapshot documentSnapshot = querySnapshots.docs.elementAt(0);

    return GroceryUser.fromFirestore(documentSnapshot);
  }

  @override
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
  }) async {
    try {
      DocumentReference ref = db.collection(Paths.usersPath).doc(uid);
      var data = {
        'accountStatus': 'Active',
        'cart': {},
        'orders': [],
        'isBlocked': false,
        'uid': uid,
        'name': name,
        'email': email,
        'mobileNo': mobileNo,
        'defaultAddress': "0",
        'profileImageUrl': profileImageUrl != null ? profileImageUrl : '',
        'tokenId': tokenId,
        'address': address,
        'wishlist': wishlist,
        'loggedInVia': loggedInVia,
      };
      ref.set(data, SetOptions(merge: true));
      final DocumentSnapshot currentDoc = await ref.get();
      user = GroceryUser.fromFirestore(currentDoc);
    } catch (e) {
      print('failed to save user details:: $e');
      user = null;
    }

    return user;
  }

  @override
  Future<List<Category>> getCategoriesList() async {
    List<Category> categories = List();
    try {
      QuerySnapshot querySnapshot =
          await db.collection(Paths.categoriesPath).get();
      for (var doc in querySnapshot.docs) {
        categories.add(Category.fromFirestore(doc));
      }
      return categories;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<Banner> getBanners() async {
    try {
      DocumentSnapshot snapshot = await db.doc(Paths.bannersPath).get();
      return Banner.fromFirestore(snapshot);
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<Product> getProduct(String id) async {
    try {
      DocumentSnapshot snapshot =
          await db.collection(Paths.productsPath).doc(id).get();
      return Product.fromFirestore(snapshot);
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  @override
  Future<List<Product>> getTrendingProducts() async {
    List<Product> trendingProducts;
    try {
      QuerySnapshot querySnapshot = await db
          .collection(Paths.productsPath)
          .where(
            'trending',
            isEqualTo: true,
          )
          .get();
      trendingProducts = List<Product>.from(
        querySnapshot.docs.map(
          (snapshot) => Product.fromFirestore(snapshot),
        ),
      );
      return trendingProducts;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<Product>> getFeaturedProducts() async {
    List<Product> featuredProducts;
    try {
      QuerySnapshot querySnapshot = await db
          .collection(Paths.productsPath)
          .where(
            'featured',
            isEqualTo: true,
          )
          .get();
      featuredProducts = List<Product>.from(
        querySnapshot.docs.map(
          (snapshot) => Product.fromFirestore(snapshot),
        ),
      );
      return featuredProducts;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<Product>> getSimilarProducts(
      String category, String subCategory, String productId) async {
    List<Product> productList;

    try {
      QuerySnapshot querySnapshot = await db
          .collection(Paths.productsPath)
          .where(
            'category',
            isEqualTo: category,
          )
          .limit(6)
          .get();
      productList = List<Product>.from(
        querySnapshot.docs.map(
          (snapshot) => Product.fromFirestore(snapshot),
        ),
      );

      for (var i = 0; i < productList.length; i++) {
        if (productList[i].id == productId) {
          productList.removeAt(i);
          break;
        }
      }

      return productList;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> addToCart(String productId, String uid) async {
    try {
      DocumentReference documentReference =
          db.collection(Paths.productsPath).doc(productId);

      await db.collection(Paths.usersPath).doc(uid).set({
        'cart': {
          productId: {
            'reference': documentReference,
            'quantity': '1',
          }
        },
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> removeFromCart(String productId, String uid) async {
    try {
      await db.collection(Paths.usersPath).doc(uid).set({
        'cart': {
          productId: FieldValue.delete(),
        },
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<CartValues> getCartValues() async {
    try {
      CartInfo cartInfo;
      PaymentMethods paymentMethods;

      DocumentSnapshot cartInfoSnap = await db.doc(Paths.cartInfo).get();
      DocumentSnapshot paymentMethodsSnap =
          await db.doc(Paths.paymentMethods).get();

      cartInfo = CartInfo.fromFirestore(cartInfoSnap);
      paymentMethods = PaymentMethods.fromFirestore(paymentMethodsSnap);

      return CartValues(
        cartInfo: cartInfo,
        paymentMethods: paymentMethods,
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<Product>> getCategoryProducts(String category) async {
    List<Product> productList;

    try {
      QuerySnapshot querySnapshot = await db
          .collection(Paths.productsPath)
          .where(
            'category',
            isEqualTo: category,
          )
          .get();
      productList = List<Product>.from(
        querySnapshot.docs.map(
          (snapshot) => Product.fromFirestore(snapshot),
        ),
      );

      return productList;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Stream<int> getCartCount(String uid) {
    DocumentReference documentReference =
        db.collection(Paths.usersPath).doc(uid);

    return documentReference.snapshots().transform(
          StreamTransformer<DocumentSnapshot, int>.fromHandlers(
            handleData: (DocumentSnapshot docSnap, EventSink<int> sink) {
              Map<String, dynamic> cart = docSnap.data()['cart'];
              if (cart != null) {
                sink.add(cart.length);
              } else {
                sink.add(0);
              }
            },
            handleError: (error, stackTrace, sink) {
              print('ERROR: $error');
              print(stackTrace);
              sink.addError(error);
            },
          ),
        );
  }

  @override
  Future<List<Cart>> getCartProducts(String uid) async {
    List<Cart> cartProducts = List();

    try {
      DocumentSnapshot userSnapshot =
          await db.collection(Paths.usersPath).doc(uid).get();
      GroceryUser currentUser = GroceryUser.fromFirestore(userSnapshot);

      for (var item in currentUser.cart.values) {
        print(item);

        DocumentSnapshot snap = await item['reference'].get();
        // Product tempProd = Product.fromFirestore(snap);
        cartProducts.add(
          Cart.fromFirestore(
            snap,
            item['quantity'],
          ),
        );
      }

      return cartProducts;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> decreaseQuantity(
      String quantity, String uid, String productId) async {
    try {
      DocumentReference documentReference =
          db.collection(Paths.productsPath).doc(productId);

      await db.collection(Paths.usersPath).doc(uid).set({
        'cart': {
          productId: {
            'reference': documentReference,
            'quantity': quantity,
          },
        },
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> increaseQuantity(
      String quantity, String uid, String productId) async {
    try {
      DocumentReference documentReference =
          db.collection(Paths.productsPath).doc(productId);

      await db.collection(Paths.usersPath).doc(uid).set({
        'cart': {
          productId: {
            'reference': documentReference,
            'quantity': quantity,
          },
        },
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<List<Product>> getWishlistProducts(String uid) async {
    List<Product> wishlistProducts = List();

    try {
      DocumentSnapshot userSnapshot =
          await db.collection(Paths.usersPath).doc(uid).get();
      GroceryUser currentUser = GroceryUser.fromFirestore(userSnapshot);

      for (var item in currentUser.wishlist) {
        print(item);

        DocumentSnapshot snap = await item.get();
        wishlistProducts.add(Product.fromFirestore(snap));
      }

      return wishlistProducts;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> addToWishlist(String productId, String uid) async {
    try {
      DocumentReference documentReference =
          db.collection(Paths.productsPath).doc(productId);

      await db.collection(Paths.usersPath).doc(uid).set({
        'wishlist': FieldValue.arrayUnion([documentReference]),
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> removeFromWishlist(String productId, String uid) async {
    try {
      DocumentReference documentReference =
          db.collection(Paths.productsPath).doc(productId);

      await db.collection(Paths.usersPath).doc(uid).set({
        'wishlist': FieldValue.arrayRemove([documentReference]),
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<Product>> getFirstSearch(String searchWord) async {
    try {
      List<Product> allProducts = List();
      QuerySnapshot querySnapshot =
          await db.collection(Paths.productsPath).get();
      for (var snapshot in querySnapshot.docs) {
        allProducts.add(Product.fromFirestore(snapshot));
      }

      return allProducts;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  List<Product> getNewSearch(String searchWord, List<Product> productsList) {
    try {
      List<Product> filteredList = List();
      for (var product in productsList) {
        if (product.name.toLowerCase().contains(searchWord)) {
          filteredList.add(product);
        }
      }
      return filteredList;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> addCard(Map<String, dynamic> card) async {
    print(card);

    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String cardsStr = sharedPreferences.getString('CARD_DATA');
      if (cardsStr != null) {
        List cardsList = json.decode(cardsStr);
        cardsList.add(card);
        sharedPreferences.setString('CARD_DATA', json.encode(cardsList));
      } else {
        List cardsList = List();
        cardsList.add(card);
        sharedPreferences.setString('CARD_DATA', json.encode(cardsList));
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> editCard(Map<String, dynamic> card, int index) async {
    print(card);

    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String cardsStr = sharedPreferences.getString('CARD_DATA');
      // if (cardsStr != null) {
      List cardsList = json.decode(cardsStr);
      cardsList.removeAt(index);
      cardsList.insert(index, card);
      sharedPreferences.setString('CARD_DATA', json.encode(cardsList));
      // } else {
      //   List cardsList = List();
      //   cardsList.add(card);
      //   sharedPreferences.setString('CARD_DATA', json.encode(cardsList));
      // }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<List> getAllCards() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      String cardsStr = sharedPreferences.getString('CARD_DATA');
      if (cardsStr != null) {
        List cardsList = json.decode(cardsStr);
        return cardsList;
      } else {
        List cardList = List();
        return cardList;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
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
  }) async {
    String orderId;
    try {
      //TODO:   1: get the orderId counter  ---------
      //TODO:   2: increment orderId counter ---------
      //TODO:   3: get the user doc --------
      //TODO:   4: create order object and write it to db ----------
      //TODO:   5: update the order id counter in db ------------
      //TODO:   6: check payment method and pay a/c to it
      //TODO:   7: delete all the cart products

//TODO: Deduct the quantity from product
//TODO: add the new order values to adminInfo

      String _paymentMethod = paymentMethod == 1 ? 'COD' : 'CARD';

      DocumentSnapshot userDoc =
          await db.collection(Paths.usersPath).doc(uid).get();
      GroceryUser user = GroceryUser.fromFirestore(userDoc);

      DocumentSnapshot orderCounterDoc =
          await db.doc(Paths.orderCounterPath).get();

      String orderPrefix = orderCounterDoc.data()['prefix'];
      String orderIdCounter = orderCounterDoc.data()['orderIdCounter'];
      orderIdCounter = (int.parse(orderIdCounter) + 1)
          .toString()
          .padLeft(orderIdCounter.length, '0');

      orderId = orderPrefix + orderIdCounter;

      List productsList = List();
      for (var prod in cartList) {
        String totalAmt =
            (double.parse(prod.product.price) * int.parse(prod.quantity))
                .toStringAsFixed(2);

        productsList.add({
          'category': prod.product.category,
          'id': prod.product.id,
          'ogPrice': prod.product.ogPrice,
          'price': prod.product.price,
          'productImage': prod.product.productImages[0],
          'quantity': prod.quantity,
          'subCategory': prod.product.subCategory,
          'totalAmt': totalAmt,
          'unitQuantity': prod.product.unitQuantity,
          'name': prod.product.name,
        });
      }

      String fullAddress =
          '${user.address[int.parse(user.defaultAddress)].houseNo}, ${user.address[int.parse(user.defaultAddress)].addressLine1}, ${user.address[int.parse(user.defaultAddress)].addressLine2}, ${user.address[int.parse(user.defaultAddress)].landmark}, ${user.address[int.parse(user.defaultAddress)].city}, ${user.address[int.parse(user.defaultAddress)].state}, ${user.address[int.parse(user.defaultAddress)].country} - ${user.address[int.parse(user.defaultAddress)].pincode}';

      //TODO: check the payment method and place order accordingly

      switch (paymentMethod) {
        case 1:
          //cod
          await db.collection(Paths.ordersPath).doc(orderId).set({
            'custDetails': {
              'address': fullAddress,
              'mobileNo': user.mobileNo,
              'name': user.name,
              'uid': uid,
              'email': user.email,
              'profileImageUrl': user.profileImageUrl,
            },
            'charges': {
              'discountAmt': discountAmt,
              'orderAmt': orderAmt,
              'shippingAmt': shippingAmt,
              'taxAmt': taxAmt,
              'totalAmt': totalAmt,
            },
            'deliveryDetails': {
              'uid': '',
              'name': '',
              'deliveryStatus': '',
              'mobileNo': '',
              'otp': '',
              'reason': '',
              'timestamp': null,
            },
            'cancelledBy': '',
            'deliveryTimestamp': null,
            'orderId': orderId,
            'orderStatus': 'Processing',
            'orderTimestamp': FieldValue.serverTimestamp(),
            'products': productsList,
            'paymentMethod': _paymentMethod,
            'reason': '',
            'refundStatus': '',
            'refundTransactionId': '',
            'transactionId': ''
          });

          await db.doc(Paths.orderCounterPath).set({
            'currentOrderId': orderId,
            'orderIdCounter': orderIdCounter,
          }, SetOptions(merge: true));

          await db.doc(Paths.orderAnalytics).set({
            'newOrders': FieldValue.increment(1),
            'newSales': FieldValue.increment(double.parse(totalAmt)),
            'totalOrders': FieldValue.increment(1),
            'totalSales': FieldValue.increment(double.parse(totalAmt)),
          }, SetOptions(merge: true));

          DocumentReference orderRef =
              db.collection(Paths.ordersPath).doc(orderId);

          //deleting all cart products and adding order ID
          await db.collection(Paths.usersPath).doc(uid).set({
            'cart': {},
            'orders': FieldValue.arrayUnion([orderRef]),
          }, SetOptions(merge: true));

          return true;
          break;
        case 2:
          //card payment
          //creating card

          String tAmt = (double.parse(totalAmt) * 100).toInt().toString();

          Map<dynamic, dynamic> paymentIntentMap = {
            'amount': tAmt,
            'currency': Config().currencyCode,
            'payment_method_types[]': 'card'
          };
          try {
            var paymentIntentRes = await http.post(
              'URL_HERE', //TODO: change this URL //it should look something like : https://us-********-**********.cloudfunctions.net/createPaymentIntent
              body: paymentIntentMap,
            );
            var paymentIntent = jsonDecode(paymentIntentRes.body);
            print(paymentIntent);

            if (paymentIntent['message'] != 'Success') {
              return false;
            }

            var paymentMethodRes = await http.post(
              'URL_HERE', //TODO: change this URL //it should look something like : https://us-********-**********.cloudfunctions.net/createPaymentMethod
              body: json.encode({
                'number': '${card.cardNumber.replaceAll(' ', '')}',
                'exp_month': '${card.expiryDate.split('/')[0]}',
                'exp_year': '${card.expiryDate.split('/')[1]}',
                'cvc': '${card.cvvCode}',
                'billing_details': {
                  'address': {
                    'city':
                        '${user.address[int.parse(user.defaultAddress)].city}',
                    'country':
                        '${user.address[int.parse(user.defaultAddress)].country}',
                    'line1':
                        '${user.address[int.parse(user.defaultAddress)].addressLine1}',
                    'line2':
                        '${user.address[int.parse(user.defaultAddress)].addressLine2}',
                    'postal_code':
                        '${user.address[int.parse(user.defaultAddress)].pincode}',
                    'state':
                        '${user.address[int.parse(user.defaultAddress)].state}',
                  },
                  'email': '${user.email}',
                  'name': '${user.name}',
                  'phone': '${user.mobileNo}',
                },
              }),
            );

            var paymentMethod = jsonDecode(paymentMethodRes.body);

            if (paymentMethod['message'] != 'Success') {
              return false;
            }

            Map<dynamic, dynamic> payM = {
              'id': paymentIntent['data']['id'],
            };
            var paymentConfirmationRes = await http.post(
              'URL_HERE', //TODO: change this URL //it should look something like : https://us-********-**********.cloudfunctions.net/confirmStripePayment
              body: payM,
            );

            var confirmation = jsonDecode(paymentConfirmationRes.body);

            if (confirmation['message'] != 'Success' ||
                confirmation['data']['status'] != 'succeeded') {
              return false;
            }

            String transactionId = paymentIntent['data']['id'];

            //updating the db
            await db.collection(Paths.ordersPath).doc(orderId).set({
              'custDetails': {
                'address': fullAddress,
                'mobileNo': user.mobileNo,
                'name': user.name,
                'uid': uid,
                'email': user.email,
                'profileImageUrl': user.profileImageUrl,
              },
              'charges': {
                'discountAmt': discountAmt,
                'orderAmt': orderAmt,
                'shippingAmt': shippingAmt,
                'taxAmt': taxAmt,
                'totalAmt': totalAmt,
              },
              'deliveryDetails': {
                'uid': '',
                'name': '',
                'deliveryStatus': '',
                'mobileNo': '',
                'otp': '',
                'reason': '',
                'timestamp': null,
              },
              'cancelledBy': '',
              'deliveryTimestamp': null,
              'orderId': orderId,
              'orderStatus': 'Processing',
              'orderTimestamp': FieldValue.serverTimestamp(),
              'products': productsList,
              'paymentMethod': _paymentMethod,
              'reason': '',
              'refundStatus': '',
              'refundTransactionId': '',
              'transactionId': transactionId,
            });

            await db.doc(Paths.orderCounterPath).set({
              'currentOrderId': orderId,
              'orderIdCounter': orderIdCounter,
            }, SetOptions(merge: true));

            await db.doc(Paths.orderAnalytics).set({
              'newOrders': FieldValue.increment(1),
              'newSales': FieldValue.increment(double.parse(totalAmt)),
              'totalOrders': FieldValue.increment(1),
              'totalSales': FieldValue.increment(double.parse(totalAmt)),
            }, SetOptions(merge: true));

            DocumentReference orderRef =
                db.collection(Paths.ordersPath).doc(orderId);

            //deleting all cart products and adding order ID
            await db.collection(Paths.usersPath).doc(uid).set({
              'cart': {},
              'orders': FieldValue.arrayUnion([orderRef]),
            }, SetOptions(merge: true));

            return true;
          } catch (e) {
            print(e);
            return false;
          }
          break;
        case 3:
          //razorpay
          await db.collection(Paths.ordersPath).doc(orderId).set({
            'custDetails': {
              'address': fullAddress,
              'mobileNo': user.mobileNo,
              'name': user.name,
              'uid': uid,
              'email': user.email,
              'profileImageUrl': user.profileImageUrl,
            },
            'charges': {
              'discountAmt': discountAmt,
              'orderAmt': orderAmt,
              'shippingAmt': shippingAmt,
              'taxAmt': taxAmt,
              'totalAmt': totalAmt,
            },
            'deliveryDetails': {
              'uid': '',
              'name': '',
              'deliveryStatus': '',
              'mobileNo': '',
              'otp': '',
              'reason': '',
              'timestamp': null,
            },
            'cancelledBy': '',
            'deliveryTimestamp': null,
            'orderId': orderId,
            'orderStatus': 'Processing',
            'orderTimestamp': FieldValue.serverTimestamp(),
            'products': productsList,
            'paymentMethod': "RAZORPAY",
            'reason': '',
            'refundStatus': '',
            'refundTransactionId': '',
            'transactionId': razorpayTxnId
          });

          await db.doc(Paths.orderCounterPath).set({
            'currentOrderId': orderId,
            'orderIdCounter': orderIdCounter,
          }, SetOptions(merge: true));

          await db.doc(Paths.orderAnalytics).set({
            'newOrders': FieldValue.increment(1),
            'newSales': FieldValue.increment(double.parse(totalAmt)),
            'totalOrders': FieldValue.increment(1),
            'totalSales': FieldValue.increment(double.parse(totalAmt)),
          }, SetOptions(merge: true));

          DocumentReference orderRef =
              db.collection(Paths.ordersPath).doc(orderId);

          //deleting all cart products and adding order ID
          await db.collection(Paths.usersPath).doc(uid).set({
            'cart': {},
            'orders': FieldValue.arrayUnion([orderRef]),
          }, SetOptions(merge: true));

          return true;
          break;
        default:
          return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<List> getAllOrders(String uid) async {
    List<MyOrder> allOrders = List();
    try {
      QuerySnapshot snapshot = await db
          .collection(Paths.ordersPath)
          .where('custDetails.uid', isEqualTo: uid)
          .orderBy('orderTimestamp', descending: true)
          .get();
      for (var order in snapshot.docs) {
        allOrders.add(MyOrder.fromFirestore(order));
      }
      return allOrders;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List> getDeliveredOrders(List<MyOrder> allOrders) async {
    List<MyOrder> deliveredOrders = List();
    try {
      for (var order in allOrders) {
        if (order.orderStatus == 'Delivered') {
          deliveredOrders.add(order);
        }
      }
      return deliveredOrders;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List> getCancelledOrders(List<MyOrder> allOrders) async {
    List<MyOrder> cancelledOrders = List();
    try {
      for (var order in allOrders) {
        if (order.orderStatus == 'Cancelled') {
          cancelledOrders.add(order);
        }
      }
      return cancelledOrders;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> cancelOrder(Map cancelOrderMap) async {
    try {
      if (cancelOrderMap['paymentMethod'] == 'COD') {
        //no refund
        await db
            .collection(Paths.ordersPath)
            .doc(cancelOrderMap['orderId'])
            .set({
          'orderStatus': 'Cancelled',
          'cancelledBy': 'Customer',
          'reason': cancelOrderMap['reason'],
          'refundStatus': 'NA',
        }, SetOptions(merge: true));
      } else {
        await db
            .collection(Paths.ordersPath)
            .doc(cancelOrderMap['orderId'])
            .set({
          'orderStatus': 'Cancelled',
          'cancelledBy': 'Customer',
          'reason': cancelOrderMap['reason'],
          'refundStatus': 'Not processed',
        }, SetOptions(merge: true));
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<GroceryUser> getAccountDetails(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await db.collection(Paths.usersPath).doc(uid).get();
      GroceryUser currentUser = GroceryUser.fromFirestore(documentSnapshot);
      return currentUser;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> addAddress(
      String uid, List<Address> address, int defaultAddress) async {
    print(address);
    List<Map> addresses = List();

    for (var add in address) {
      Map tempAdd = Map();
      tempAdd.putIfAbsent('addressLine1', () => add.addressLine1);
      tempAdd.putIfAbsent('addressLine2', () => add.addressLine2);
      tempAdd.putIfAbsent('city', () => add.city);
      tempAdd.putIfAbsent('state', () => add.state);
      tempAdd.putIfAbsent('country', () => add.country);
      tempAdd.putIfAbsent('houseNo', () => add.houseNo);
      tempAdd.putIfAbsent('landmark', () => add.landmark);
      tempAdd.putIfAbsent('pincode', () => add.pincode);

      addresses.add(tempAdd);
    }

    try {
      await db.collection(Paths.usersPath).doc(uid).set({
        'address': addresses,
        'defaultAddress': defaultAddress.toString(),
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> removeAddress(
      String uid, List<Address> address, bool isDefault) async {
    List<Map> addresses = List();

    for (var add in address) {
      Map tempAdd = Map();
      tempAdd.putIfAbsent('addressLine1', () => add.addressLine1);
      tempAdd.putIfAbsent('addressLine2', () => add.addressLine2);
      tempAdd.putIfAbsent('city', () => add.city);
      tempAdd.putIfAbsent('state', () => add.state);
      tempAdd.putIfAbsent('country', () => add.country);
      tempAdd.putIfAbsent('houseNo', () => add.houseNo);
      tempAdd.putIfAbsent('landmark', () => add.landmark);
      tempAdd.putIfAbsent('pincode', () => add.pincode);

      addresses.add(tempAdd);
    }

    if (isDefault) {
      //change default address to 0
      try {
        await db.collection(Paths.usersPath).doc(uid).set({
          'address': addresses,
          'defaultAddress': address.length > 0 ? '0' : '-1',
        }, SetOptions(merge: true));
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      try {
        await db.collection(Paths.usersPath).doc(uid).set({
          'address': addresses,
        }, SetOptions(merge: true));
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    }
  }

  @override
  Future<bool> editAddress(
      String uid, List<Address> address, int defaultAddress) async {
    List<Map> addresses = List();

    for (var add in address) {
      Map tempAdd = Map();
      tempAdd.putIfAbsent('addressLine1', () => add.addressLine1);
      tempAdd.putIfAbsent('addressLine2', () => add.addressLine2);
      tempAdd.putIfAbsent('city', () => add.city);
      tempAdd.putIfAbsent('state', () => add.state);
      tempAdd.putIfAbsent('country', () => add.country);
      tempAdd.putIfAbsent('houseNo', () => add.houseNo);
      tempAdd.putIfAbsent('landmark', () => add.landmark);
      tempAdd.putIfAbsent('pincode', () => add.pincode);

      addresses.add(tempAdd);
    }

    try {
      await db.collection(Paths.usersPath).doc(uid).set({
        'address': addresses,
        'defaultAddress': defaultAddress.toString(),
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> updateAccountDetails(GroceryUser user, File profileImage) async {
    try {
      if (profileImage != null) {
        //upload profile image first
        var uuid = Uuid().v4();
        StorageReference storageReference =
            firebaseStorage.ref().child('profileImages/$uuid');
        StorageUploadTask storageUploadTask =
            storageReference.putFile(profileImage);
        StorageTaskSnapshot storageTaskSnapshot =
            await storageUploadTask.onComplete;
        var url = await storageTaskSnapshot.ref.getDownloadURL();

        await db.collection(Paths.usersPath).doc(user.uid).set({
          'name': user.name,
          'email': user.email,
          'mobileNo': user.mobileNo,
          'profileImageUrl': url,
        }, SetOptions(merge: true));
      } else {
        //just update details
        await db.collection(Paths.usersPath).doc(user.uid).set({
          'name': user.name,
          'email': user.email,
          'mobileNo': user.mobileNo,
          'profileImageUrl': user.profileImageUrl,
        }, SetOptions(merge: true));
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> postQuestion(
      String uid, String productId, String question) async {
    try {
      DocumentSnapshot documentSnapshot =
          await db.collection(Paths.usersPath).doc(uid).get();
      GroceryUser currentUser = GroceryUser.fromFirestore(documentSnapshot);

      String randomId = Uuid().v4();
      await db.collection(Paths.productsPath).doc(productId).set({
        'queAndAns': {
          randomId: {
            'ans': '',
            'que': question,
            'timestamp': Timestamp.now(),
            'userId': uid,
            'userName': currentUser.name,
            'queId': randomId,
          }
        }
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<Map<dynamic, dynamic>> checkRateProduct(
      String uid, String productId, Product product) async {
    List<MyOrder> orders = List();
    Review review;
    Map<dynamic, dynamic> res = Map();
//TODO: 1st check if the uid exists in the product -->> if it exists that means already rated
//TODO: 2nd check the orders collection and act accordingly

    try {
      //checking the product reviews
      for (var item in product.reviews) {
        if (item.userId == uid) {
          review = item;
          res.putIfAbsent('review', () => review);
          res.putIfAbsent('result', () => 'RATED');

          return res;
        }
      }

      //getting the orders
      QuerySnapshot querySnapshot = await db
          .collection(Paths.ordersPath)
          .where('custDetails.uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.length > 0) {
        for (var item in querySnapshot.docs) {
          orders.add(MyOrder.fromFirestore(item));
        }

        for (var order in orders) {
          for (var prod in order.products) {
            if (prod.id == productId) {
              //ordered previously
              //check if review exists

              for (var rev in product.reviews) {
                if (rev.userId == uid) {
                  review = rev;
                  res.putIfAbsent('review', () => review);
                  res.putIfAbsent('result', () => 'RATED');

                  return res;
                }
              }

              res.putIfAbsent('review', () => review);
              res.putIfAbsent('result', () => 'NOT_RATED');
              return res;
            }
          }
        }
      }

      res.putIfAbsent('review', () => review);
      res.putIfAbsent('result', () => 'NOT_ORDERED');
      return res;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> rateProduct(String uid, String productId, String rating,
      String review, String result, Product product) async {
    try {
      DocumentSnapshot documentSnapshot =
          await db.collection(Paths.usersPath).doc(uid).get();
      GroceryUser currentUser = GroceryUser.fromFirestore(documentSnapshot);

      String reviewId;

      if (result == 'RATED') {
        // get the reviews and then update

        for (var item in product.reviews) {
          if (item.userId == uid) {
            reviewId = item.reviewId;

            await db.collection(Paths.productsPath).doc(productId).set({
              'reviews': {
                reviewId: {
                  'rating': rating,
                  'review': review,
                  'timestamp': Timestamp.now(),
                  'userId': uid,
                  'userName': currentUser.name,
                  'reviewId': reviewId,
                }
              }
            }, SetOptions(merge: true));

            return true;
          }
        }

        // String randomId = Uuid().v4();
        // await db.collection(Paths.productsPath).doc(productId).set({
        //   'reviews': {
        //     randomId: {
        //       'rating': rating,
        //       'review': review,
        //       'timestamp': Timestamp.now(),
        //       'userId': uid,
        //       'userName': currentUser.name,
        //       'reviewId': randomId,
        //     }
        //   }
        // }, SetOptions(merge: true));

        // List<Map> reviews = List();

        // for (var rev in product.reviews) {
        //   Map tempRev = Map();
        //   tempRev.putIfAbsent('rating', () => rev.rating);
        //   tempRev.putIfAbsent('review', () => rev.review);
        //   tempRev.putIfAbsent('timestamp', () => rev.timestamp);
        //   tempRev.putIfAbsent('userId', () => rev.userId);
        //   tempRev.putIfAbsent('userName', () => rev.userName);

        //   reviews.add(tempRev);
        // }

        // for (var i = 0; i < reviews.length; i++) {
        //   if (reviews[i]['userId'] == uid) {
        //     reviews[i] = Map.of({
        //       'rating': rating,
        //       'review': review,
        //       'timestamp': Timestamp.now(),
        //       'userId': uid,
        //       'userName': currentUser.name,
        //     });
        //   }
        // }

        // await db.collection(Paths.productsPath).doc(productId).set(
        //   {
        //     'reviews': reviews,
        //   },
        //   SetOptions(merge: true),
        // );
      } else {
        String randomId = Uuid().v4();
        await db.collection(Paths.productsPath).doc(productId).set({
          'reviews': {
            randomId: {
              'rating': rating,
              'review': review,
              'timestamp': Timestamp.now(),
              'userId': uid,
              'userName': currentUser.name,
              'reviewId': randomId,
            }
          }
        }, SetOptions(merge: true));
      }

      return true;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> incrementView(String productId) async {
    try {
      await db.collection(Paths.productsPath).doc(productId).set({
        'views': FieldValue.increment(1),
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<List<Product>> getBannerAllProducts(String category) async {
    try {
      List<Product> products = List();
      QuerySnapshot querySnapshot = await db
          .collection(Paths.productsPath)
          .where('category', isEqualTo: category)
          .get();

      products = List<Product>.from(
        (querySnapshot.docs).map(
          (doc) => Product.fromFirestore(doc),
        ),
      );
      return products;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Stream<UserNotification> getNotifications(String uid) {
    DocumentReference documentReference =
        db.collection(Paths.noticationsPath).doc(uid);

    print('inside notifications');
    return documentReference.snapshots().transform(
          StreamTransformer<DocumentSnapshot, UserNotification>.fromHandlers(
            handleData:
                (DocumentSnapshot docSnap, EventSink<UserNotification> sink) {
              UserNotification userNotification =
                  UserNotification.fromFirestore(docSnap);
              print('UID :: ${userNotification.uid}');
              sink.add(userNotification);
            },
            handleError: (error, stackTrace, sink) {
              print('ERROR: $error');
              print(stackTrace);
              sink.addError(error);
            },
          ),
        );
  }

  @override
  Future<void> markNotificationRead(String uid) async {
    try {
      await db.collection(Paths.noticationsPath).doc(uid).set({
        'unread': false,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> reportProduct(
      String uid, String productId, String reportDescription) async {
    try {
      DocumentSnapshot documentSnapshot =
          await db.collection(Paths.usersPath).doc(uid).get();
      GroceryUser currentUser = GroceryUser.fromFirestore(documentSnapshot);

      String reportId = Uuid().v4();

      await db.collection(Paths.userReportsPath).doc(reportId).set({
        'productId': productId,
        'reportDescription': reportDescription,
        'timestamp': FieldValue.serverTimestamp(),
        'uid': currentUser.uid,
        'userName': currentUser.name,
        'reportId': reportId,
      });

      return true;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
