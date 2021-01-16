import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store_delivery/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'sign_in_screens/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SignInBloc signInBloc;
  Map<dynamic, Widget> mapping = {
    1: SignInScreen(),
    2: HomeScreen(),
  };

  @override
  void initState() {
    super.initState();

    signInBloc = BlocProvider.of<SignInBloc>(context);

    signInBloc.listen((state) {
      print(state);
      if (state is CheckIfSignedInEventCompletedState) {
        //proceed to home
        if (state.res.isEmpty) {
          Navigator.popAndPushNamed(context, '/home');
        } else {
          Navigator.popAndPushNamed(context, '/sign_in');
        }
      }

      if (state is CheckIfSignedInEventFailedState) {
        //proceed to sign in
        print('failed to check if logged in');
        Navigator.popAndPushNamed(context, '/sign_in');
      }
    });

    signInBloc.add(CheckIfSignedInEvent());
  }

  @override
  Widget build(BuildContext context) {
    // Timer(Duration(milliseconds: 0), () {
    //   Navigator.popAndPushNamed(context, '/sign_in');
    // });
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/delivery.svg',
              width: size.width * 0.25,
              height: size.width * 0.25,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Grocery Store Delivery',
              style: GoogleFonts.poppins(
                color: Colors.black.withOpacity(0.85),
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
