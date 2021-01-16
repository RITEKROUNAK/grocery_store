import 'package:ecommerce_store_admin/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'sign_in_sign_up_screens/sign_in_screen.dart';

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

  //TODO: check if initial setup is done for the first time and save it in shared prefs

  @override
  void initState() {
    super.initState();

    signInBloc = BlocProvider.of<SignInBloc>(context);

    signInBloc.listen((state) {
      if (state is CheckIfSignedInEventCompletedState) {
        //proceed to home
        if (state.isSignedIn) {
          print('logged in');
          checkIfInitialSetupIsCompleteSignedIn();
        } else {
          //not signed in
          print('not logged in');
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

  checkIfInitialSetupIsCompleteSignedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isSetupCompleted = sharedPreferences.getBool('initialSetupCompleted');

    if (isSetupCompleted == null) {
      //not done
      Navigator.popAndPushNamed(context, '/initial_setup');
    } else {
      if (isSetupCompleted) {
        //done
        Navigator.popAndPushNamed(context, '/home');
      } else {
        //not done
        Navigator.popAndPushNamed(context, '/initial_setup');
      }
    }
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
              'assets/icons/shop.svg',
              width: size.width * 0.25,
              height: size.width * 0.25,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Grocery Store Admin',
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
