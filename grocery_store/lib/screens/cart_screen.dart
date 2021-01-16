import 'package:grocery_store/blocs/cart_bloc/cart_bloc.dart';
import 'package:grocery_store/blocs/sign_in_bloc/signin_bloc.dart';
import 'package:grocery_store/config/config.dart';
import 'package:grocery_store/models/cart.dart';
import 'package:grocery_store/models/cart_values.dart';
import 'package:grocery_store/widget/cart_item.dart';
import 'package:grocery_store/widget/shimmer_cart_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc cartBloc;
  SigninBloc signinBloc;
  User currentUser;
  CartValues cartValues;
  List<Cart> cartProducts = List();
  double totalOrderAmt, totalAmt, discountAmt, shippingAmt, taxAmt;

  bool isUserLoaded;
  bool isPriceLoaded;

  @override
  void initState() {
    super.initState();

    totalAmt = 0;
    totalOrderAmt = 0;
    discountAmt = 0;
    shippingAmt = 0;
    taxAmt = 0;

    isUserLoaded = false;
    isPriceLoaded = false;
    cartBloc = BlocProvider.of<CartBloc>(context);
    signinBloc = BlocProvider.of<SigninBloc>(context);

    signinBloc.listen((state) {
      print('SIGN IN BLOC :: $state');

      if (state is GetCurrentUserCompleted) {
        currentUser = state.firebaseUser;
        cartBloc.add(GetCartProductsEvent(currentUser.uid));
        // cartBloc.add(GetCartValuesEvent());
      }
    });

    cartBloc.listen((state) {
      print(state);
      if (state is GetCartProductsCompletedState) {
        print(state.cartProductsList.length);
        cartBloc.add(GetCartValuesEvent());
      }
      if (state is RemoveFromCartInProgressState) {
        showRemovingProductDialog();
        isPriceLoaded = false;
      }
      if (state is RemoveFromCartCompletedState) {
        Navigator.of(context).pop();
      }
    });

    signinBloc.add(GetCurrentUser());

    // if (!isUserLoaded) {
    //   signinBloc.add(GetCurrentUser());
    //   isUserLoaded = true;
    // }
  }

  void showRemovingProductDialog() {
    showDialog(
      context: context,
      child: AlertDialog(
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              width: 10.0,
            ),
            Text(
              'Removing the product',
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: GoogleFonts.poppins(
                color: Colors.black.withOpacity(0.9),
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void showSnack(String text, BuildContext context) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: 8.0,
      backgroundColor: Colors.red.shade500,
      animationDuration: Duration(milliseconds: 300),
      isDismissible: true,
      boxShadows: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 1.0,
          blurRadius: 5.0,
          offset: Offset(0.0, 2.0),
        )
      ],
      shouldIconPulse: false,
      duration: Duration(milliseconds: 2500),
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
      messageText: Text(
        '$text',
        style: GoogleFonts.poppins(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          color: Colors.white,
        ),
      ),
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.white.withOpacity(0.5),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    width: 38.0,
                                    height: 35.0,
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 24.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              'My Cart',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                        BlocBuilder(
                          cubit: cartBloc,
                          buildWhen: (previous, current) {
                            if (current is GetCartProductsInProgressState ||
                                current is GetCartProductsCompletedState ||
                                current is GetCartProductsFailedState) {
                              return true;
                            }
                            return false;
                          },
                          builder: (context, state) {
                            if (state is GetCartProductsInProgressState) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 12.0),
                                child: Text(
                                  'Items: --',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              );
                            }
                            if (state is GetCartProductsCompletedState) {
                              cartProducts = state.cartProductsList;

                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 12.0),
                                child: Text(
                                  'Items: ${state.cartProductsList.length}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              );
                            }
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white.withOpacity(0.2),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 12.0),
                              child: Text(
                                'Items: --',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  shrinkWrap: false,
                  children: <Widget>[
                    BlocBuilder(
                      cubit: cartBloc,
                      buildWhen: (previous, current) {
                        if (current is GetCartProductsInProgressState ||
                            current is GetCartProductsFailedState ||
                            current is GetCartProductsCompletedState ||
                            current is IncreaseQuantityInProgressState ||
                            current is IncreaseQuantityCompletedState) {
                          return true;
                        }
                        return false;
                      },
                      builder: (context, state) {
                        if (state is GetCartProductsInProgressState) {
                          return ListView.separated(
                            itemCount: 5,
                            physics: NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                period: Duration(milliseconds: 800),
                                baseColor: Colors.grey.withOpacity(0.5),
                                highlightColor: Colors.black.withOpacity(0.5),
                                child: ShimmerCartItem(size: size),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 20.0);
                            },
                          );
                        }
                        if (state is GetCartProductsFailedState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/banners/retry.svg',
                                width: size.width * 0.6,
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Text(
                                'Failed to get products in cart!',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                                style: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.9),
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                            ],
                          );
                        }
                        if (state is GetCartProductsCompletedState ||
                            state is IncreaseQuantityInProgressState ||
                            state is IncreaseQuantityCompletedState ||
                            state is RemoveFromCartCompletedState) {
                          if (state is GetCartProductsCompletedState) {
                            cartProducts = state.cartProductsList;
                          }
                          if (cartProducts.length == 0) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/images/empty_cart.svg',
                                  width: size.width * 0.6,
                                ),
                                SizedBox(
                                  height: 25.0,
                                ),
                                Text(
                                  'Cart is empty',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            );
                          }

                          return Column(
                            children: <Widget>[
                              ListView.separated(
                                itemCount: cartProducts.length,
                                padding: const EdgeInsets.all(0.0),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return CartItem(
                                    cartProducts: cartProducts,
                                    index: index,
                                    size: size,
                                    product: cartProducts[index].product,
                                    quantity: cartProducts[index].quantity,
                                    cartBloc: cartBloc,
                                    currentUser: currentUser,
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 20.0);
                                },
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              BlocBuilder(
                                cubit: cartBloc,
                                buildWhen: (previous, current) {
                                  if (current is GetCartValuesCompletedState ||
                                      current is GetCartValuesFailedState ||
                                      current is GetCartValuesInProgressState) {
                                    return true;
                                  }
                                  return false;
                                },
                                builder: (context, state) {
                                  //TODO: add shimmer item
                                  if (state is GetCartValuesInProgressState) {
                                    return CircularProgressIndicator();
                                  }
                                  if (state is GetCartValuesFailedState) {
                                    return Text('Failed');
                                  }
                                  if (state is GetCartValuesCompletedState) {
                                    cartValues = state.cartValues;
                                    isPriceLoaded = true;
                                    //calculate total amount and other values

                                    totalAmt = 0;
                                    totalOrderAmt = 0;
                                    discountAmt = 0;
                                    taxAmt = 0;
                                    shippingAmt =
                                        double.parse(cartValues.cartInfo.shippingAmt);
                                    for (var product in cartProducts) {
                                      totalOrderAmt = totalOrderAmt +
                                          (double.parse(product.product.price) *
                                              int.parse(product.quantity));
                                    }

                                    if (totalOrderAmt >
                                        double.parse(cartValues.cartInfo.discountAmt)) {
                                      discountAmt = (double.parse(
                                                  cartValues.cartInfo.discountPer) /
                                              100) *
                                          totalOrderAmt;
                                    }

                                    taxAmt = (double.parse(cartValues.cartInfo.taxPer) /
                                            100) *
                                        totalOrderAmt;

                                    totalAmt = totalOrderAmt +
                                        taxAmt +
                                        shippingAmt -
                                        discountAmt;

                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                      ),
                                      padding: const EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 0.0),
                                            blurRadius: 15.0,
                                            spreadRadius: 2.0,
                                            color:
                                                Colors.black.withOpacity(0.05),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Icon(
                                                Icons.local_offer,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 25.0,
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Get ${cartValues.cartInfo.discountPer}% discount on orders above ${Config().currency}${cartValues.cartInfo.discountAmt}',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black87,
                                                    fontSize: 15.5,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              // Icon(
                                              //   Icons.check_circle,
                                              //   size: 22.0,
                                              //   color: Theme.of(context).primaryColor,
                                              // ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Divider(),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Text(
                                                'Order:',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                              Text(
                                                '${Config().currency}${totalOrderAmt.toStringAsFixed(2)}',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Text(
                                                'Shipping:',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                              Text(
                                                '${Config().currency}${shippingAmt.toStringAsFixed(2)}',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Text(
                                                'Tax (${cartValues.cartInfo.taxPer}%):',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                              Text(
                                                '${Config().currency}${taxAmt.toStringAsFixed(2)}',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Text(
                                                'Discount:',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.green
                                                      .withOpacity(0.85),
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                              Text(
                                                '- ${Config().currency}${discountAmt.toStringAsFixed(2)}',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.green
                                                      .withOpacity(0.85),
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Divider(),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Text(
                                                'Total:',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black
                                                      .withOpacity(0.85),
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                              Text(
                                                '${Config().currency}${totalAmt.toStringAsFixed(2)}',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black
                                                      .withOpacity(0.85),
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return SizedBox();
                                },
                              ),
                              SizedBox(
                                height: 90.0,
                              ),
                            ],
                          );
                        }
                        return SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          BlocBuilder(
            cubit: cartBloc,
            buildWhen: (previous, current) {
              if (current is GetCartProductsInProgressState ||
                  current is GetCartProductsFailedState ||
                  current is GetCartProductsCompletedState ||
                  current is RemoveFromCartInProgressState ||
                  current is RemoveFromCartFailedState ||
                  current is RemoveFromCartCompletedState) {
                return true;
              }
              return false;
            },
            builder: (context, state) {
              if (state is GetCartProductsCompletedState) {
                if (state.cartProductsList.length > 0) {
                  return Positioned(
                    bottom: 0,
                    child: Container(
                      height: 80.0,
                      width: size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white70,
                            Colors.white54,
                            Colors.white10,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          // temmpMethod();
                          for (var item in cartProducts) {
                            if (!item.product.inStock) {
                              //dont allow as OUT OF STOCK
                              showSnack(
                                  'Your cart have Out of stock items!\nPlease remove them to continue.',
                                  context);
                              return;
                            }
                          }
                          if (!isPriceLoaded) {
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(
                                cartProducts: cartProducts,
                                discountAmt: discountAmt,
                                shippingAmt: shippingAmt,
                                totalAmt: totalAmt,
                                taxAmt: taxAmt,
                                totalOrderAmt: totalOrderAmt,
                                currentUser: currentUser,
                                cartValues: cartValues,
                              ),
                            ),
                          );
                        },
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 18.0,
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text(
                              'CHECKOUT',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
              return SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
