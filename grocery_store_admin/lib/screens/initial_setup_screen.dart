import 'dart:math';

import 'package:ecommerce_store_admin/blocs/initial_setup_bloc/initial_setup_bloc.dart';
import 'package:ecommerce_store_admin/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/processing_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class InitialSetupScreen extends StatefulWidget {
  @override
  _InitialSetupScreenState createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String discountAmt, discountPer, shippingAmt, taxPer;
  SignInBloc signInBloc;
  InitialSetupBloc initialSetupBloc;
  bool inProgress;

  @override
  void initState() {
    super.initState();

    inProgress = false;
    signInBloc = BlocProvider.of<SignInBloc>(context);
    initialSetupBloc = BlocProvider.of<InitialSetupBloc>(context);

    signInBloc.listen((state) {
      print('SIGN IN BLOC :: $state');
    });

    initialSetupBloc.listen((state) {
      print('INITIAL SETUP BLOC :: $state');

      if (state is ProceedInitialSetupInProgressState) {
        //in progress
        if (inProgress) {
          showUpdatingDialog();
        }
      }
      if (state is ProceedInitialSetupFailedState) {
        //FAILED
        if (inProgress) {
          Navigator.pop(context);
          setState(() {
            inProgress = false;
            showSnack('Failed to proceed!', context);
          });
        }
      }
      if (state is ProceedInitialSetupCompletedState) {
        //completed
        if (inProgress) {
          //send to home
          Navigator.pop(context);
          setState(() {
            inProgress = false;
            showSnack('Initial setup successful!', context);
          });
          Navigator.popAndPushNamed(context, '/home');
        }
      }
    });
  }

  proceedSetup() {
    FocusScope.of(context).unfocus();
    _formKey.currentState.save();
    Map map = Map();
    map.putIfAbsent('discountAmt', () => discountAmt);
    map.putIfAbsent('discountPer', () => discountPer);
    map.putIfAbsent('shippingAmt', () => shippingAmt);
    map.putIfAbsent('taxPer', () => taxPer);

    initialSetupBloc.add(ProceedInitialSetupEvent(map));

    inProgress = true;
  }

  showUpdatingDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProcessingDialog(
          message: 'Setting up app..\nPlease wait!',
        );
      },
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(
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
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'Initial Setup',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 19.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                children: <Widget>[
                  Text(
                    'Hello,',
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Welcome to the initial setup of your grocery store app.',
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    'Fill out the form below:',
                    style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    width: size.width,
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                      top: 15.0,
                      bottom: 15.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '1) Do you want to provide any discount above a minimum cart total amount? \n(If left blank then \"0\" will be considered)',
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
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                    textInputAction: TextInputAction.done,
                                    enableInteractiveSelection: false,
                                    maxLines: 1,
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
                            '2) Input the discount percent? \n(If left blank then \"0\" will be considered)',
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
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    textInputAction: TextInputAction.done,
                                    enableInteractiveSelection: false,
                                    maxLines: 1,
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
                            '3) Do you want to charge any shipping amount? \n(If left blank then \"0\" will be considered)',
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
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    textInputAction: TextInputAction.done,
                                    enableInteractiveSelection: false,
                                    maxLines: 1,
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
                            '4) Do you want to charge any tax? \n(If left blank then \"0\" will be considered)',
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
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    textInputAction: TextInputAction.done,
                                    enableInteractiveSelection: false,
                                    maxLines: 1,
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
                            height: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    height: 45.0,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: FlatButton(
                      onPressed: () {
                        proceedSetup();
                      },
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        'Proceed',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
