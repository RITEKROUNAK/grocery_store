import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store_delivery/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store_delivery/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:grocery_store_delivery/config/config.dart';
import 'package:grocery_store_delivery/models/user.dart';
import 'package:grocery_store_delivery/screens/account_screens/account_settings_screen.dart';
import 'package:grocery_store_delivery/widgets/dialogs/processing_dialog.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  AccountBloc accountBloc;
  SignInBloc signInBloc;
  User firebaseUser;
  DeliveryUser user;

  bool isSigningOut;

  @override
  void initState() {
    super.initState();

    isSigningOut = false;
    accountBloc = BlocProvider.of<AccountBloc>(context);
    signInBloc = BlocProvider.of<SignInBloc>(context);

    accountBloc.add(GetAccountDetailsEvent());

    signInBloc.listen((state) {
      if (state is SignOutEventInProgressState) {
        //show dialog
        if (isSigningOut) {
          showUpdatingDialog();
        }
      }
      if (state is SignOutEventFailedState) {
        //show failed dialog
        if (isSigningOut) {
          showSnack('Failed to sign out!', context);
          isSigningOut = false;
        }
      }
      if (state is SignOutEventCompletedState) {
        //take to splash screen
        if (isSigningOut) {
          isSigningOut = false;
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/sign_in',
            (route) => false,
          );
        }
      }
    });
  }

  Future sendToAccountSettings() async {
    bool isUpdated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountSettingsScreen(
          user: user,
        ),
      ),
    );

    if (isUpdated != null) {
      if (isUpdated) {
        accountBloc.add(GetAccountDetailsEvent());
      }
    }
  }

  Future inviteAFriend() async {
    await FlutterShare.share(
      title: 'Checkout this amazing app!',
      text: 'Grocery Store',
      linkUrl:
          Config().playStoreLink, //TODO: change it according to the platform
      chooserTitle: 'Share to apps',
    );
  }

  Future feedback() async {
    final Email email = Email(
      body: '',
      subject: 'Grocery Store Demo Support',
      isHTML: false,
      recipients: ['support.grocery_demo@gmail.com'],
    );

    await FlutterEmailSender.send(email);
  }

  showUpdatingDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProcessingDialog(
          message: 'Signing out..\nPlease wait!',
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

  showSignoutConfimationDialog(Size size) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        elevation: 5.0,
        contentPadding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Are you sure?',
              style: GoogleFonts.poppins(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              'Do you want to sign out?',
              style: GoogleFonts.poppins(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 50.0,
                  child: FlatButton(
                    padding: const EdgeInsets.all(0.0),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'No',
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 50.0,
                  child: FlatButton(
                    padding: const EdgeInsets.all(0.0),
                    onPressed: () {
                      Navigator.pop(context);
                      signInBloc.add(SignOutEvent());
                      isSigningOut = true;
                    },
                    child: Text(
                      'Yes',
                      style: GoogleFonts.poppins(
                        color: Colors.red.shade700,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
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
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      'Profile',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 19.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.white.withOpacity(0.5),
                          onTap: () {
                            print('Logout');
                            //show confirmation dialog
                            showSignoutConfimationDialog(size);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            width: 40.0,
                            height: 37.0,
                            alignment: Alignment.center,
                            child: FaIcon(
                              FontAwesomeIcons.signOutAlt,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder(
              buildWhen: (previous, current) {
                if (current is GetAccountDetailsCompletedState ||
                    current is GetAccountDetailsFailedState ||
                    current is GetAccountDetailsInProgressState) {
                  return true;
                }
                return false;
              },
              cubit: accountBloc,
              builder: (context, state) {
                print('ACCOUNT DETAILS BLOC :: $state');

                if (state is GetAccountDetailsInProgressState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is GetAccountDetailsFailedState) {
                  return Center(
                    child: Text(
                      'Failed to load user!',
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  );
                }
                if (state is GetAccountDetailsCompletedState) {
                  user = state.user;

                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Center(
                        child: Container(
                          height: size.width * 0.3,
                          width: size.width * 0.3,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/icons/icon_person.png',
                              placeholderScale: 0.5,
                              imageErrorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                Icons.person,
                                size: 50.0,
                              ),
                              image: mounted ? user.profileImageUrl : '',
                              fit: BoxFit.cover,
                              fadeInDuration: Duration(milliseconds: 250),
                              fadeInCurve: Curves.easeInOut,
                              fadeOutDuration: Duration(milliseconds: 150),
                              fadeOutCurve: Curves.easeInOut,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        '${user.name}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          // color: Colors.black.withOpacity(0.025),
                        ),
                        child: Column(
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                if (user != null) {
                                  sendToAccountSettings();
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.tune,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        Text(
                                          'Account Settings',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.3,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black38,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Divider(),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            FlatButton(
                              onPressed: () {
                                inviteAFriend();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.person_add,
                                          color: Colors.black54,
                                        ),
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        Text(
                                          'Invite a Friend',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.3,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            FlatButton(
                              onPressed: () {
                                feedback();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.email,
                                          color: Colors.black54,
                                        ),
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        Text(
                                          'Feedback',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.3,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
