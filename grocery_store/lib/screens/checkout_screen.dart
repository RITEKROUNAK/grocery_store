import 'dart:convert';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/blocs/checkout_bloc/checkout_bloc.dart';
import 'package:grocery_store/config/config.dart';
import 'package:grocery_store/models/cart.dart';
import 'package:grocery_store/models/cart_values.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/account_settings_screen.dart';
import 'package:grocery_store/screens/card_payment_screen.dart';
import 'package:grocery_store/widget/order_placed_dialog.dart';
import 'package:grocery_store/widget/place_order_dialog.dart';
import 'package:grocery_store/widget/processing_dialog.dart';
import 'package:grocery_store/widget/shimmer_checkout_address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class CheckoutScreen extends StatefulWidget {
  final List<Cart> cartProducts;
  final double totalOrderAmt, totalAmt, discountAmt, shippingAmt, taxAmt;
  final User currentUser;
  final CartValues cartValues;

  const CheckoutScreen({
    this.cartProducts,
    this.totalOrderAmt,
    this.totalAmt,
    this.discountAmt,
    this.shippingAmt,
    this.taxAmt,
    this.currentUser,
    this.cartValues,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  CheckoutBloc checkoutBloc;
  bool proceed;
  bool placeOrder;
  int selectedPayment = 0;
  AccountBloc accountBloc;
  GroceryUser user;
  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    checkoutBloc = BlocProvider.of<CheckoutBloc>(context);
    accountBloc = BlocProvider.of<AccountBloc>(context);

    proceed = false;
    initRazorpay();

    accountBloc.add(GetAccountDetailsEvent(widget.currentUser.uid));

    checkoutBloc.listen((state) {
      print('CHECKOUT STATE ::: $state');
      if (state is ProceedOrderCompletedState) {
        if (state.res == 'CARD') {
          //move to card payment screen
          if (proceed) {
            proceed = false;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CardPaymentScreen(
                  cartProducts: widget.cartProducts,
                  discountAmt: widget.discountAmt,
                  shippingAmt: widget.shippingAmt,
                  totalAmt: widget.totalAmt,
                  totalOrderAmt: widget.totalOrderAmt,
                  currentUser: widget.currentUser,
                  cartValues: widget.cartValues,
                  taxAmt: widget.taxAmt,
                ),
              ),
            );
          }
        } else {
          if (proceed) {
            checkoutBloc.add(PlaceOrderEvent(
              cartList: widget.cartProducts,
              discountAmt: widget.discountAmt.toStringAsFixed(2),
              orderAmt: widget.totalOrderAmt.toStringAsFixed(2),
              taxAmt: widget.taxAmt.toStringAsFixed(2),
              paymentMethod: 1,
              shippingAmt: widget.shippingAmt.toStringAsFixed(2),
              totalAmt: widget.totalAmt.toStringAsFixed(2),
              uid: widget.currentUser.uid,
            ));
          }
        }
      }
      if (state is PlaceOrderInProgressState) {
        showPlacingOrderDialog();
      }
      if (state is PlaceOrderCompletedState) {
        if (proceed) {
          Navigator.pop(context);
          showOrderPlaceDialog();
          proceed = false;
        }
      }
      if (state is PlaceOrderFailedState) {
        if (proceed) {
          Navigator.pop(context);
          showSnack('Failed to place order!', context);
          proceed = false;
        }
      }
    });
  }

  showPlacingOrderDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return PlaceOrderDialog();
      },
    );
  }

  showOrderPlaceDialog() async {
    var res = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return OrderPlacedDialog();
      },
    );

    if (res == 'PLACED') {
      //placed
      //TODO: take user to my orders
      Navigator.popUntil(context, ModalRoute.withName('/home'));
    }
  }

  void proceedOrder(int paymentMode) {
    print(paymentMode);
    print(proceed);

    switch (paymentMode) {
      case 1:
        //COD
        if (proceed) {
          checkoutBloc.add(PlaceOrderEvent(
            cartList: widget.cartProducts,
            discountAmt: widget.discountAmt.toStringAsFixed(2),
            orderAmt: widget.totalOrderAmt.toStringAsFixed(2),
            taxAmt: widget.taxAmt.toStringAsFixed(2),
            paymentMethod: 1,
            shippingAmt: widget.shippingAmt.toStringAsFixed(2),
            totalAmt: widget.totalAmt.toStringAsFixed(2),
            uid: widget.currentUser.uid,
          ));
        }
        break;
      case 2:
        //Stripe
        if (proceed) {
          proceed = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardPaymentScreen(
                cartProducts: widget.cartProducts,
                discountAmt: widget.discountAmt,
                shippingAmt: widget.shippingAmt,
                totalAmt: widget.totalAmt,
                totalOrderAmt: widget.totalOrderAmt,
                currentUser: widget.currentUser,
                cartValues: widget.cartValues,
                taxAmt: widget.taxAmt,
              ),
            ),
          );
        }
        break;
      case 3:
        //Razorpay
        print('pay via razorpay');
        payViaRazorpay();
        break;
      default:
    }
  }

  showProcessingDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProcessingDialog(
          message: 'Please wait!\nWe are processing order...',
        );
      },
    );
  }

  initRazorpay() {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  //RAZORPAY
  void payViaRazorpay() async {
    showProcessingDialog();

    var createOrderIdResp = await http.post(
      Config().razorpayCreateOrderIdUrl,
      body: json.encode({
        'amount': widget.totalAmt.toInt() * 100,
      }),
    );

    var razorpayOrderId = jsonDecode(createOrderIdResp.body);

    var options = {
      'key': Config().razorpayKey,
      'amount':
          widget.totalAmt.toInt() * 100, //in the smallest currency sub-unit.
      'name': Config().companyName,
      'order_id': razorpayOrderId['data']['id'],
      'description': 'New order payment',
      'timeout': 60, // in seconds
      'prefill': {
        'contact': user.mobileNo,
        'email': user.email,
      }
    };

    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print(response.paymentId);
    print(response.orderId);
    print(response.signature);
    Navigator.pop(context);
    // showSnack('Payment successful!', context);

    checkoutBloc.add(PlaceOrderEvent(
      cartList: widget.cartProducts,
      discountAmt: widget.discountAmt.toStringAsFixed(2),
      orderAmt: widget.totalOrderAmt.toStringAsFixed(2),
      taxAmt: widget.taxAmt.toStringAsFixed(2),
      paymentMethod: 3,
      shippingAmt: widget.shippingAmt.toStringAsFixed(2),
      totalAmt: widget.totalAmt.toStringAsFixed(2),
      uid: widget.currentUser.uid,
      razorpayTxnId: response.paymentId,
    ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print(response);
    Navigator.pop(context);
    showSnack('Payment failed!', context);
    proceed = false;
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print(response);
    Navigator.pop(context);
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
      duration: Duration(milliseconds: 2000),
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

  // Future callFunction() async {
  //   print('calling function');

  // }

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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
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
                          'Checkout',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0.0),
                            blurRadius: 15.0,
                            spreadRadius: 2.0,
                            color: Colors.black.withOpacity(0.05),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: Text(
                              'Select a payment method',
                              style: GoogleFonts.poppins(
                                color: Colors.black87,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          widget.cartValues.paymentMethods.cod
                              ? RadioListTile(
                                  activeColor: Theme.of(context).primaryColor,
                                  dense: true,
                                  value: 1,
                                  groupValue: selectedPayment,
                                  title: Text(
                                    'Cash on delivery',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black87,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedPayment = val;
                                    });
                                  },
                                )
                              : SizedBox(),
                          widget.cartValues.paymentMethods.stripe
                              ? RadioListTile(
                                  activeColor: Theme.of(context).primaryColor,
                                  dense: true,
                                  value: 2,
                                  groupValue: selectedPayment,
                                  title: Text(
                                    'Pay via Credit/Debit card',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black87,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedPayment = val;
                                    });
                                  },
                                )
                              : SizedBox(),
                          widget.cartValues.paymentMethods.razorpay
                              ? RadioListTile(
                                  activeColor: Theme.of(context).primaryColor,
                                  dense: true,
                                  value: 3,
                                  groupValue: selectedPayment,
                                  title: Text(
                                    'Pay via Razorpay',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black87,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedPayment = val;
                                    });
                                  },
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    BlocBuilder(
                      cubit: accountBloc,
                      buildWhen: (previous, current) {
                        if (current is GetAccountDetailsCompletedState ||
                            current is GetAccountDetailsInProgressState ||
                            current is GetAccountDetailsFailedState) {
                          return true;
                        }
                        return false;
                      },
                      builder: (context, state) {
                        if (state is GetAccountDetailsInProgressState) {
                          return Shimmer.fromColors(
                            period: Duration(milliseconds: 1000),
                            baseColor: Colors.grey.withOpacity(0.5),
                            highlightColor: Colors.black.withOpacity(0.5),
                            child: ShimmerCheckoutAddress(
                              size: size,
                            ),
                          );
                        }
                        if (state is GetAccountDetailsFailedState) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 0.0),
                                  blurRadius: 15.0,
                                  spreadRadius: 2.0,
                                  color: Colors.black.withOpacity(0.05),
                                ),
                              ],
                            ),
                            child: Column(
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
                                  'Failed to get shipping details!',
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
                                Container(
                                  height: 38.0,
                                  width: size.width * 0.5,
                                  child: FlatButton(
                                    onPressed: () {
                                      accountBloc.add(GetAccountDetailsEvent(
                                          widget.currentUser.uid));
                                    },
                                    color: Colors.red.shade400,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Text(
                                      'Retry',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        if (state is GetAccountDetailsCompletedState) {
                          user = state.user;

                          if (state.user.address.length == 0) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 0.0),
                                    blurRadius: 15.0,
                                    spreadRadius: 2.0,
                                    color: Colors.black.withOpacity(0.05),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Shipping details :',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black87,
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Center(
                                    child: Text(
                                      'No address found!',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.8),
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Container(
                                    height: 42.0,
                                    width: double.infinity,
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AccountSettingsScreen(
                                              currentUser: widget.currentUser,
                                            ),
                                          ),
                                        );
                                      },
                                      color: Colors.green.shade400,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Text(
                                        'Add address',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 0.0),
                                  blurRadius: 15.0,
                                  spreadRadius: 2.0,
                                  color: Colors.black.withOpacity(0.05),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Shipping details :',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  '${user.name}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Text(
                                  user.mobileNo.isEmpty
                                      ? 'Mobile No. : NA'
                                      : '${user.mobileNo}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Text(
                                  '${user.address[int.parse(user.defaultAddress)].houseNo}, ${user.address[int.parse(user.defaultAddress)].addressLine1}, ${user.address[int.parse(user.defaultAddress)].addressLine2}, ${user.address[int.parse(user.defaultAddress)].landmark}, ${user.address[int.parse(user.defaultAddress)].city}, ${user.address[int.parse(user.defaultAddress)].state}, ${user.address[int.parse(user.defaultAddress)].country} - ${user.address[int.parse(user.defaultAddress)].pincode}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Container(
                                  height: 42.0,
                                  width: double.infinity,
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AccountSettingsScreen(
                                            currentUser: widget.currentUser,
                                          ),
                                        ),
                                      );
                                    },
                                    color: Colors.green.shade400,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Text(
                                      'Change address',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return SizedBox();
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0.0),
                            blurRadius: 15.0,
                            spreadRadius: 2.0,
                            color: Colors.black.withOpacity(0.05),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Icon(
                                Icons.local_offer,
                                color: Theme.of(context).primaryColor,
                                size: 25.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Text(
                                  'Get ${widget.cartValues.cartInfo.discountPer}% discount on orders above ${Config().currency}${widget.cartValues.cartInfo.discountAmt}',
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                'Order:',
                                style: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Text(
                                '${Config().currency}${widget.totalOrderAmt.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.7),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                'Shipping:',
                                style: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Text(
                                '${Config().currency}${widget.shippingAmt.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.7),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                'Tax (${widget.cartValues.cartInfo.taxPer}%):',
                                style: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Text(
                                '${Config().currency}${widget.taxAmt.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.7),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                'Discount:',
                                style: GoogleFonts.poppins(
                                  color: Colors.green.withOpacity(0.85),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Text(
                                '- ${Config().currency}${widget.discountAmt.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  color: Colors.green.withOpacity(0.85),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                'Total:',
                                style: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.85),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Text(
                                '${Config().currency}${widget.totalAmt.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.85),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 90.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 80.0,
              width: size.width,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                  if (selectedPayment != 0) {
                    if (user.address.length > 0) {
                      if (user.mobileNo.isNotEmpty) {
                        proceed = true;
                        proceedOrder(selectedPayment);
                      } else {
                        showSnack(
                            'Please add mobile no. to your account', context);
                      }
                    } else {
                      showSnack('Please add your address', context);
                    }
                  } else {
                    showSnack('Select a payment method', context);
                  }
                },
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  'CONFIRM & PROCEED',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
