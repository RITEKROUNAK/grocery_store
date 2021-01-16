import 'package:ecommerce_store_admin/blocs/manage_cart_bloc/manage_cart_bloc.dart';
import 'package:ecommerce_store_admin/models/cart_info.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/processing_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageCartPage extends StatefulWidget {
  @override
  _ManageCartPageState createState() => _ManageCartPageState();
}

class _ManageCartPageState extends State<ManageCartPage>
    with AutomaticKeepAliveClientMixin {
  ManageCartBloc manageCartBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name, email, mobileNo;
  bool primaryAdmin;
  bool inProgress;
  String discountAmt, discountPer, shippingAmt, taxPer;

  CartInfo cartInfo;

  @override
  void initState() {
    super.initState();

    manageCartBloc = BlocProvider.of<ManageCartBloc>(context);
    manageCartBloc.add(GetCartInfo());

    manageCartBloc.listen((state) {
      print('MY ACCOUNT BLOC :: $state');

      if (state is UpdateCartInfoInProgressState) {
        //in progress
        if (inProgress) {
          showUpdatingDialog();
        }
      }
      if (state is UpdateCartInfoFailedState) {
        //FAILED
        if (inProgress) {
          Navigator.pop(context);
          inProgress = false;
          showSnack('Failed to update!', context);
        }
      }
      if (state is UpdateCartInfoCompletedState) {
        //completed
        if (inProgress) {
          //done
          Navigator.pop(context);
          inProgress = false;
          showCompletedSnack('Cart info updated successfully!', context);
        }
      }
    });
  }

  showUpdatingDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProcessingDialog(
          message: 'Updating account details..\nPlease wait!',
        );
      },
    );
  }

  void showCompletedSnack(String text, BuildContext context) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: 8.0,
      backgroundColor: Colors.green.shade500,
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
        Icons.done,
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

  updateCartInfo() async {
//Temp disable
    // showSnack('You\'re not a Primary admin.\nAction not allowed!', context);

    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();
      _formKey.currentState.save();

      Map adminMap = Map();
      adminMap.putIfAbsent('discountAmt', () => discountAmt);
      adminMap.putIfAbsent('discountPer', () => discountPer);
      adminMap.putIfAbsent('shippingAmt', () => shippingAmt);
      adminMap.putIfAbsent('taxPer', () => taxPer);

      manageCartBloc.add(UpdateCartInfo(adminMap));

      inProgress = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocBuilder(
          cubit: manageCartBloc,
          buildWhen: (previous, current) {
            if (current is GetCartInfoInProgressState ||
                current is GetCartInfoFailedState ||
                current is GetCartInfoCompletedState) {
              return true;
            }
            return false;
          },
          builder: (context, state) {
            if (state is GetCartInfoInProgressState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is GetCartInfoFailedState) {
              return Center(
                child: Text('FAILED TO LOAD!'),
              );
            }
            if (state is GetCartInfoCompletedState) {
              cartInfo = state.cartInfo;

              return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  children: <Widget>[
                    Text(
                      'Do you want to provide any discount above a minimum cart total amount? \n(If left blank then \"0\" will be considered)',
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Minimum Amount:  ',
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 40.0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextFormField(
                              onSaved: (val) {
                                if (val.trim().length > 0) {
                                  discountAmt = val.trim();
                                } else {
                                  discountAmt = '0';
                                }
                              },
                              keyboardType: TextInputType.numberWithOptions(),
                              textInputAction: TextInputAction.done,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              initialValue: cartInfo.discountAmt,
                              style: GoogleFonts.poppins(
                                fontSize: 14.0,
                                color: Colors.black87,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 8.0),
                                border: InputBorder.none,
                                hintText: 'eg: 499',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 14.0,
                                  color: Colors.black54,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Input the discount percent? \n(If left blank then \"0\" will be considered)',
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Discount Percent:  ',
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 40.0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextFormField(
                              onSaved: (val) {
                                if (val.trim().length > 0) {
                                  discountPer = val.trim();
                                } else {
                                  discountPer = '0';
                                }
                              },
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              textInputAction: TextInputAction.done,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              initialValue: cartInfo.discountPer,
                              style: GoogleFonts.poppins(
                                fontSize: 14.0,
                                color: Colors.black87,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 8.0),
                                border: InputBorder.none,
                                hintText: 'eg: 10',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 14.0,
                                  color: Colors.black54,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Do you want to charge any shipping amount? \n(If left blank then \"0\" will be considered)',
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Shipping Charge:  ',
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 40.0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextFormField(
                              onSaved: (val) {
                                if (val.trim().length > 0) {
                                  shippingAmt = val.trim();
                                } else {
                                  shippingAmt = '0';
                                }
                              },
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              textInputAction: TextInputAction.done,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              initialValue: cartInfo.shippingAmt,
                              style: GoogleFonts.poppins(
                                fontSize: 14.0,
                                color: Colors.black87,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 8.0),
                                border: InputBorder.none,
                                hintText: 'eg: 50',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 14.0,
                                  color: Colors.black54,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Do you want to charge any tax? \n(If left blank then \"0\" will be considered)',
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Tax Percent:  ',
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 40.0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextFormField(
                              onSaved: (val) {
                                if (val.trim().length > 0) {
                                  taxPer = val.trim();
                                } else {
                                  taxPer = '0';
                                }
                              },
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              textInputAction: TextInputAction.done,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              initialValue: cartInfo.taxPer,
                              style: GoogleFonts.poppins(
                                fontSize: 14.0,
                                color: Colors.black87,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 8.0),
                                border: InputBorder.none,
                                hintText: 'eg: 18',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 14.0,
                                  color: Colors.black54,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 45.0,
                      width: size.width,
                      child: FlatButton(
                        onPressed: () {
                          //update
                          updateCartInfo();
                        },
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Text(
                          'Update Cart Settings',
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
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
