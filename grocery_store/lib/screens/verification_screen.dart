import 'dart:async';

import 'package:grocery_store/blocs/sign_up_bloc/signup_bloc.dart';
import 'package:grocery_store/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class VerificationScreen extends StatefulWidget {
  final String mobileNo;
  final String name;
  final String email;
  final bool isSigningIn;

  const VerificationScreen({
    this.mobileNo,
    this.email,
    this.name,
    this.isSigningIn,
  });

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  int _timer;
  SignupBloc signupBloc;
  MaskedTextController otpController = MaskedTextController(mask: '000000');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer timer;

  bool inProgress;

  String smsCode;

  @override
  void initState() {
    super.initState();

    signupBloc = BlocProvider.of<SignupBloc>(context);
    inProgress = false;

    signupBloc.listen((state) {
      if (state is VerifyMobileNoCompleted) {
        //proceed and save the data
        print('USER ID: ${state.user.uid}');
        // setState(() {
        //   inProgress = false;
        // });

        if (widget.isSigningIn) {
          //sign in
          //proceed to home
          //close signupBloc

          signupBloc.close();
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          );
        } else {
          //sign up
          signupBloc.add(
            SaveUserDetails(
              name: widget.name,
              mobileNo: widget.mobileNo,
              email: widget.email,
              firebaseUser: state.user,
              loggedInVia: 'MOBILE_NO',
            ),
          );
        }
      }
      if (state is VerifyMobileNoInProgress) {
        //show progress bar
        print('verification in progress');
        setState(() {
          inProgress = true;
        });
      }
      if (state is VerifyMobileNoFailed) {
        //failed
        print('verification failed');
        showFailedSnakbar('Verification failed!');
        setState(() {
          inProgress = false;
        });
      }
      if (state is VerificationCompleted) {
        //proceed and save the data
        print('sent otp');
        setState(() {
          inProgress = false;
        });
      }
      if (state is VerificationInProgress) {
        //show progress bar
        print('verification in progress');
        setState(() {
          inProgress = true;
        });
      }
      if (state is VerificationFailed) {
        //failed
        print('verification failed');
        showFailedSnakbar('Failed to send otp!');
        setState(() {
          inProgress = false;
        });
      }
      if (state is CompletedSavingUserDetails) {
        print(state.user.mobileNo);
        //proceed to home
        //close signupBloc

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
      }
      if (state is FailedSavingUserDetails) {
        //failed saving user details
        print('failed to save');
        showFailedSnakbar('Failed to save user details!');

        setState(() {
          inProgress = false;
        });
      }
      if (state is SavingUserDetails) {
        //saving user details
        print('Saving user details');
      }
    });

    signupBloc.add(
      SignupWithMobileNo(
        name: widget.name,
        mobileNo: widget.mobileNo,
        email: widget.email,
      ),
    );

    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = 60;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timer--;
      });
      if (_timer == 0) {
        timer.cancel();
      }
    });
  }

  void showFailedSnakbar(String s) {
    SnackBar snackbar = SnackBar(
      content: Text(
        s,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Theme.of(context).primaryColor,
      action: SnackBarAction(
          label: 'OK', textColor: Colors.white, onPressed: () {}),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
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
                            'Verification',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: size.height * 0.2,
              child: SvgPicture.asset(
                'assets/banners/verification.svg',
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'ENTER CODE',
              style: GoogleFonts.poppins(
                color: Colors.black.withOpacity(0.85),
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              'An OTP is sent to your mobile number',
              style: GoogleFonts.poppins(
                color: Colors.black.withOpacity(0.7),
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Container(
              height: 52.0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              child: TextFormField(
                controller: otpController,
                textAlignVertical: TextAlignVertical.center,
                validator: (String val) {
                  if (val.isEmpty) {
                    return 'OTP is required';
                  } else if (val.length < 6) {
                    return 'OTP is invalid';
                  }
                  return null;
                },
                onChanged: (val) {
                  smsCode = val;
                },
                enableInteractiveSelection: false,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  helperStyle: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.65),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  errorStyle: GoogleFonts.poppins(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  hintStyle: GoogleFonts.poppins(
                    // color: Colors.black54,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  hintText: 'OTP',
                  // labelText: 'OTP',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              height: 40.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      '$_timer sec',
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  _timer == 0
                      ? FlatButton(
                          onPressed: () {
                            print('Resend OTP');
                            signupBloc.add(
                              SignupWithMobileNo(
                                name: widget.name,
                                mobileNo: widget.mobileNo,
                                email: widget.email,
                              ),
                            );
                            startTimer();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Text(
                            'Resend OTP',
                            style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            buildVerificationBtn(context, inProgress),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVerificationBtn(BuildContext context, bool inProgress) {
    return inProgress
        ? Center(child: CircularProgressIndicator())
        : Container(
            width: double.infinity,
            height: 48.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FlatButton(
              onPressed: () {
                // Navigator.pushNamed(context, '/checkout');
                signupBloc.add(VerifyMobileNo(smsCode));
                setState(() {
                  inProgress = true;
                });
              },
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                'Verify',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          );
  }
}
