import 'package:grocery_store/config/config.dart';
import 'package:grocery_store/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static final String id = 'onboarding_screen_id';

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Config config;

  @override
  void initState() {
    super.initState();

    config = Config();
  }

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        image: SvgPicture.asset(
          config.onboardingImage1,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          fit: BoxFit.contain,
        ),
        title: config.onboardingPage1Title,
        body: config.onboardingPage1Subtitle,
        decoration: PageDecoration(
          imageFlex: 1,
          bodyTextStyle: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      PageViewModel(
        image: SvgPicture.asset(
          config.onboardingImage2,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          fit: BoxFit.contain,
        ),
        title: config.onboardingPage2Title,
        body: config.onboardingPage2Subtitle,
        decoration: PageDecoration(
          imageFlex: 1,
          bodyTextStyle: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      PageViewModel(
        image: SvgPicture.asset(
          config.onboardingImage3,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          fit: BoxFit.contain,
        ),
        title: config.onboardingPage3Title,
        body: config.onboardingPage3Subtitle,
        decoration: PageDecoration(
          imageFlex: 1,
          bodyTextStyle: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          pages: getPages(),
          showNextButton: true,
          next: Text(
            'Next',
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          onDone: () {
            //TODO: change it to sign in screen
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
                (route) => false);
          },
          done: Text(
            'Done',
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
