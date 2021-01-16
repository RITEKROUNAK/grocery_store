import 'dart:convert';

import 'package:grocery_store/blocs/card_bloc/card_bloc.dart';
import 'package:grocery_store/blocs/checkout_bloc/checkout_bloc.dart';
import 'package:grocery_store/config/config.dart';
import 'package:grocery_store/models/cart.dart';
import 'package:grocery_store/models/cart_values.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/screens/add_card_screen.dart';
import 'package:grocery_store/widget/order_placed_dialog.dart';
import 'package:grocery_store/widget/place_order_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/card.dart' as prefix;

class CardPaymentScreen extends StatefulWidget {
  final List<Cart> cartProducts;
  final double totalOrderAmt, totalAmt, discountAmt, shippingAmt, taxAmt;
  final User currentUser;
  final CartValues cartValues;

  const CardPaymentScreen({
    this.cartProducts,
    this.totalOrderAmt,
    this.totalAmt,
    this.discountAmt,
    this.shippingAmt,
    this.currentUser,
    this.cartValues,
    this.taxAmt,
  });

  @override
  _CardPaymentScreenState createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  CheckoutBloc checkoutBloc;
  int selectedCard;
  SharedPreferences sharedPreferences;
  CardBloc cardBloc;
  List cardsList;
  bool proceed;

  @override
  void initState() {
    super.initState();

    checkoutBloc = BlocProvider.of<CheckoutBloc>(context);
    cardBloc = BlocProvider.of<CardBloc>(context);

    selectedCard = 0;
    proceed = false;

    cardBloc.add(GetAllCardsEvent());

    cardsList = List();

    // cardBloc.listen((state) {
    //   if (state is GetAllCardsCompletedState) {
    //     if (state.cardsList != null) {
    //       print(state.cardsList);
    //       cardsList = state.cardsList;
    //     } else {
    //       //no cards saved
    //     }
    //   }
    // });

    checkoutBloc.listen((state) {
      print('CHECKOUT STATE ::: $state');

      if (state is PlaceOrderInProgressState) {
        if (proceed) {
          showPlacingOrderDialog();
        }
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

  Future placeOrder() async {
    if (cardsList.length > 0) {
      prefix.Card card = prefix.Card(
        cardHolderName: cardsList[selectedCard]['cardHolderName'],
        cardNumber: cardsList[selectedCard]['cardNumber'],
        cvvCode: cardsList[selectedCard]['cvvCode'],
        expiryDate: cardsList[selectedCard]['expiryDate'],
      );

      checkoutBloc.add(
        PlaceOrderEvent(
          cartList: widget.cartProducts,
          discountAmt: widget.discountAmt.toStringAsFixed(2),
          orderAmt: widget.totalOrderAmt.toStringAsFixed(2),
          paymentMethod: 2,
          shippingAmt: widget.shippingAmt.toStringAsFixed(2),
          totalAmt: widget.totalAmt.toStringAsFixed(2),
          taxAmt: widget.taxAmt.toStringAsFixed(2),
          uid: widget.currentUser.uid,
          card: card,
        ),
      );
      proceed = true;
    } else {
      showSnack('No cards found!', context);
    }
  }

  Future addCard() async {
    bool isAdded = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddCardScreen(),
        ));
    if (isAdded != null) {
      if (isAdded) {
        //refresh
        print('REFRESH');
        cardBloc.add(GetAllCardsEvent());
      }
    }
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
                          'Pay via Card',
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 16.0,
                                bottom: 10.0),
                            child: Text(
                              'Select a card',
                              style: GoogleFonts.poppins(
                                color: Colors.black87,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          BlocBuilder(
                            cubit: cardBloc,
                            buildWhen: (previous, current) {
                              if (current is GetAllCardsCompletedState ||
                                  current is GetAllCardsInProgressState ||
                                  current is GetAllCardsFailedState) {
                                return true;
                              }
                              return false;
                            },
                            builder: (context, state) {
                              if (state is GetAllCardsInProgressState) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              if (state is GetAllCardsFailedState) {
                                return Center(
                                  child: Text(
                                    'FAILED TO GET CARDS',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black87,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                );
                              }
                              if (state is GetAllCardsCompletedState) {
                                if (state.cardsList != null) {
                                  cardsList = state.cardsList;
                                }
                                if (cardsList.length == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/images/credit_card.png',
                                            width: size.width * 0.6,
                                          ),
                                          SizedBox(
                                            height: 15.0,
                                          ),
                                          Text(
                                            'No cards found',
                                            style: GoogleFonts.poppins(
                                              color: Colors.black87,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return Column(
                                  children: <Widget>[
                                    ListView.separated(
                                      itemCount: cardsList.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.all(0),
                                      itemBuilder: (context, index) {
                                        String cardNum = cardsList[index]
                                                ['cardNumber']
                                            .toString()
                                            .replaceRange(2, 17, '** **** **');
                                        return GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            setState(() {
                                              selectedCard = index;
                                            });
                                          },
                                          child: Container(
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      Radio(
                                                        value: index,
                                                        groupValue:
                                                            selectedCard,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedCard =
                                                                index;
                                                          });
                                                        },
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          Text(
                                                            cardNum,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.3,
                                                            ),
                                                          ),
                                                          Text(
                                                            cardsList[index][
                                                                'cardHolderName'],
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.7),
                                                              fontSize: 13.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.3,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                selectedCard == index
                                                    ? CreditCardWidget(
                                                        cardNumber:
                                                            cardsList[index]
                                                                ['cardNumber'],
                                                        expiryDate:
                                                            cardsList[index]
                                                                ['expiryDate'],
                                                        cardHolderName: cardsList[
                                                                index]
                                                            ['cardHolderName'],
                                                        cvvCode:
                                                            cardsList[index]
                                                                ['cvvCode'],
                                                        showBackView: false,
                                                        height: 195,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        animationDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    1000),
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                          height: 8.0,
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 12.0,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.1),
                                      child: Center(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Divider(
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                              child: Text(
                                                'OR',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black54,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Divider(
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return SizedBox();
                            },
                          ),

                          SizedBox(
                            height: 20.0,
                          ),
                          // CreditCardWidget(
                          //   cardNumber: cardsList[index]['cardNumber'],
                          //   expiryDate: cardsList[index]['expiryDate'],
                          //   cardHolderName: cardsList[index]['cardHolderName'],
                          //   cvvCode: cardsList[index]['cvvCode'],
                          //   showBackView: false,
                          //   height: 195,
                          //   width: MediaQuery.of(context).size.width,
                          //   animationDuration: Duration(milliseconds: 1000),
                          // ),
                          Container(
                            height: 43.0,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 0),
                            child: FlatButton(
                              onPressed: () {
                                addCard();
                              },
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Text(
                                'Add a card',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
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
                  placeOrder();
                },
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  'PLACE ORDER',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
