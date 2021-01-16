import 'package:ecommerce_store_admin/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:ecommerce_store_admin/blocs/payment_method_settings_bloc/payment_method_settings_bloc.dart';
import 'package:ecommerce_store_admin/models/inventory_analytics.dart';
import 'package:ecommerce_store_admin/models/payment_methods.dart';
import 'package:ecommerce_store_admin/screens/inventory_screens/all_categories_screen.dart';
import 'package:ecommerce_store_admin/screens/inventory_screens/low_inventory_screen.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/processing_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethodSettingsPage extends StatefulWidget {
  @override
  _PaymentMethodSettingsPageState createState() =>
      _PaymentMethodSettingsPageState();
}

class _PaymentMethodSettingsPageState extends State<PaymentMethodSettingsPage>
    with AutomaticKeepAliveClientMixin {
  PaymentMethodSettingsBloc paymentMethodSettingsBloc;
  PaymentMethods paymentMethods;
  bool inProgress;

  @override
  void initState() {
    super.initState();

    inProgress = false;
    paymentMethodSettingsBloc =
        BlocProvider.of<PaymentMethodSettingsBloc>(context);

    paymentMethodSettingsBloc.add(GetPaymentMethods());

    paymentMethodSettingsBloc.listen((state) {
      print('MY ACCOUNT BLOC :: $state');

      if (state is UpdatePaymentMethodsInProgressState) {
        //in progress
        if (inProgress) {
          showUpdatingDialog();
        }
      }
      if (state is UpdatePaymentMethodsFailedState) {
        //FAILED
        if (inProgress) {
          Navigator.pop(context);
          inProgress = false;
          showSnack('Failed to update!', context);
        }
      }
      if (state is UpdatePaymentMethodsCompletedState) {
        //completed
        if (inProgress) {
          //done
          Navigator.pop(context);
          inProgress = false;
          showCompletedSnack(
              'Payment method settings updated successfully!', context);
        }
      }
    });
  }

  updatePaymentMethodSettings() {
    //Temp disable
    // showSnack('You\'re not a Primary admin.\nAction not allowed!', context);

    Map adminMap = Map();
    adminMap.putIfAbsent('cod', () => paymentMethods.cod);
    adminMap.putIfAbsent('stripe', () => paymentMethods.stripe);
    adminMap.putIfAbsent('paypal', () => paymentMethods.paypal);
    adminMap.putIfAbsent('razorpay', () => paymentMethods.razorpay);
    adminMap.putIfAbsent('storePickup', () => paymentMethods.storePickup);

    paymentMethodSettingsBloc.add(UpdatePaymentMethods(adminMap));

    inProgress = true;
  }

  showUpdatingDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProcessingDialog(
          message: 'Updating payment methods..\nPlease wait!',
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocBuilder(
        cubit: paymentMethodSettingsBloc,
        buildWhen: (previous, current) {
          if (current is GetPaymentMethodsInProgressState ||
              current is GetPaymentMethodsFailedState ||
              current is GetPaymentMethodsCompletedState) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is GetPaymentMethodsInProgressState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GetPaymentMethodsFailedState) {
            return Text('FAILED');
          }
          if (state is GetPaymentMethodsCompletedState) {
            paymentMethods = state.paymentMethods;

            print(paymentMethods.cod);

            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Cash on delivery',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    FlutterSwitch(
                      width: 60.0,
                      height: 30.0,
                      valueFontSize: 14.0,
                      toggleSize: 15.0,
                      value: paymentMethods.cod,
                      activeColor: Theme.of(context).primaryColor,
                      inactiveColor: Colors.black38,
                      borderRadius: 15.0,
                      padding: 8.0,
                      onToggle: (val) {
                        setState(() {
                          paymentMethods.cod = val;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Stripe',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    FlutterSwitch(
                      width: 60.0,
                      height: 30.0,
                      valueFontSize: 14.0,
                      toggleSize: 15.0,
                      value: paymentMethods.stripe,
                      activeColor: Theme.of(context).primaryColor,
                      inactiveColor: Colors.black38,
                      borderRadius: 15.0,
                      padding: 8.0,
                      onToggle: (val) {
                        setState(() {
                          paymentMethods.stripe = val;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Razorpay',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    FlutterSwitch(
                      width: 60.0,
                      height: 30.0,
                      valueFontSize: 14.0,
                      toggleSize: 15.0,
                      value: paymentMethods.razorpay,
                      activeColor: Theme.of(context).primaryColor,
                      inactiveColor: Colors.black38,
                      borderRadius: 15.0,
                      padding: 8.0,
                      onToggle: (val) {
                        setState(() {
                          paymentMethods.razorpay = val;
                        });
                      },
                    ),
                  ],
                ),
                // SizedBox(
                //   height: 10.0,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisSize: MainAxisSize.max,
                //   children: <Widget>[
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Text(
                //         'Store pickup',
                //         style: GoogleFonts.poppins(
                //           color: Colors.black87,
                //           fontSize: 15.0,
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //     ),
                //     FlutterSwitch(
                //       width: 60.0,
                //       height: 30.0,
                //       valueFontSize: 14.0,
                //       toggleSize: 15.0,
                //       value: paymentMethods.storePickup,
                //       activeColor: Theme.of(context).primaryColor,
                //       inactiveColor: Colors.black38,
                //       borderRadius: 15.0,
                //       padding: 8.0,
                //       onToggle: (val) {
                //         setState(() {
                //           paymentMethods.storePickup = val;
                //         });
                //       },
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 10.0,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisSize: MainAxisSize.max,
                //   children: <Widget>[
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Text(
                //         'Paypal',
                //         style: GoogleFonts.poppins(
                //           color: Colors.black87,
                //           fontSize: 15.0,
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //     ),
                //     FlutterSwitch(
                //       width: 60.0,
                //       height: 30.0,
                //       valueFontSize: 14.0,
                //       toggleSize: 15.0,
                //       value: paymentMethods.paypal,
                //       activeColor: Theme.of(context).primaryColor,
                //       inactiveColor: Colors.black38,
                //       borderRadius: 15.0,
                //       padding: 8.0,
                //       onToggle: (val) {
                //         setState(() {
                //           paymentMethods.paypal = val;
                //         });
                //       },
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  height: 45.0,
                  width: size.width,
                  child: FlatButton(
                    onPressed: () {
                      //update
                      updatePaymentMethodSettings();
                    },
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Text(
                      'Update Payment Methods',
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
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
