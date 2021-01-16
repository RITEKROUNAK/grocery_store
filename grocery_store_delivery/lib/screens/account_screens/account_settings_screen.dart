import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store_delivery/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store_delivery/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:grocery_store_delivery/config/config.dart';
import 'package:grocery_store_delivery/models/user.dart';
import 'package:grocery_store_delivery/widgets/dialogs/change_password_dialog.dart';
import 'package:grocery_store_delivery/widgets/dialogs/processing_dialog.dart';
import 'package:grocery_store_delivery/widgets/dialogs/task_completed_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AccountSettingsScreen extends StatefulWidget {
  final DeliveryUser user;

  const AccountSettingsScreen({this.user});
  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  AccountBloc accountBloc;
  DeliveryUser user;
  SignInBloc signInBloc;
  TextEditingController mobileNoController;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String mobileNo, email, name;
  bool inProgress;
  bool isUpdated;

  var image;
  File selectedProfileImage;

  @override
  void initState() {
    super.initState();

    isUpdated = false;
    mobileNoController = TextEditingController();
    accountBloc = BlocProvider.of<AccountBloc>(context);
    signInBloc = BlocProvider.of<SignInBloc>(context);

    accountBloc.add(GetAccountDetailsEvent());

    // user = widget.user;

    accountBloc.listen((state) {
      print(state);
      if (state is GetAccountDetailsCompletedState) {
        user = state.user;

        name = user.name;
        email = user.email;
        mobileNo = user.mobileNo;

        mobileNo = mobileNo.replaceFirst(Config().countryMobileNoPrefix, '');

        nameController.text = name;
        mobileNoController.text = mobileNo;
        emailController.text = email;
      }
      if (state is UpdateAccountDetailsInProgressState) {
        //show dialog
        showUpdatingDialog('Updating account details..\nPlease wait!');
      }
      if (state is UpdateAccountDetailsFailedState) {
        //show error
        showSnack('Failed to update account details!', context);
      }
      if (state is UpdateAccountDetailsCompletedState) {
        //show dialog
        Navigator.pop(context);
        Navigator.pop(context, true);
      }
    });

    signInBloc.listen((state) {
      if (state is ChangePasswordEventInProgressState) {
        //show dialog
        showUpdatingDialog('Sending password reset request..\nPlease wait!');
      }
      if (state is ChangePasswordEventFailedState) {
        //show error
        showSnack('Failed to update account details!', context);
      }
      if (state is ChangePasswordEventCompletedState) {
        //show dialog
        Navigator.pop(context);
        showChangedPasswordDialog('Password reset link sent on your email');
      }
    });
  }

  showChangedPasswordDialog(String message) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return TaskCompletedDialog(
          message: '$message',
        );
      },
    );
  }

  showUpdatingDialog(String message) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProcessingDialog(
          message: '$message',
        );
      },
    );
  }

  showchangePasswordConfimationDialog(Size size) {
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
              'Do you want to change password?',
              style: GoogleFonts.poppins(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              'You\'ll be sent a password reset link on your email.',
              style: GoogleFonts.poppins(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.3,
                color: Colors.black54,
              ),
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
                      signInBloc.add(ChangePasswordEvent(user));
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

  showChangePasswordDialog() async {
    bool isChanged = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ChangePasswordDialog(
          user: user,
        );
      },
    );

    if (isChanged != null) {
      if (isChanged) {
        //call change password event

      }
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

  Future updateAccountDetails() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      user.name = name;
      user.email = email;
      user.mobileNo = '${Config().countryMobileNoPrefix}$mobileNo';

      if (selectedProfileImage != null) {
        //upload profile image
        accountBloc.add(UpdateAccountDetailsEvent(
            user: user, profileImage: selectedProfileImage));
      } else {
        //only update account details
        accountBloc.add(UpdateAccountDetailsEvent(user: user));
      }

      isUpdated = true;
    }
  }

  Future cropImage(context) async {
    image = await ImagePicker().getImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        cropStyle: CropStyle.circle,
        compressFormat: ImageCompressFormat.jpg,
        maxHeight: 400,
        maxWidth: 400,
        compressQuality: 50,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop image',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          showCropGrid: false,
          lockAspectRatio: true,
          statusBarColor: Theme.of(context).primaryColor,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
        ));

    if (croppedFile != null) {
      print('File size: ' + croppedFile.lengthSync().toString());
      setState(() {
        selectedProfileImage = croppedFile;
      });
      // signupBloc.add(PickedProfilePictureEvent(file: croppedFile));
    } else {
      //not croppped

    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
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
                      'Account Settings',
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
            child: BlocBuilder(
              cubit: accountBloc,
              buildWhen: (previous, current) {
                if (current is GetAccountDetailsInProgressState ||
                    current is GetAccountDetailsFailedState ||
                    current is GetAccountDetailsCompletedState) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is GetAccountDetailsInProgressState) {
                  //TODO: add shimmmer
                  return Center(child: CircularProgressIndicator());
                }
                if (state is GetAccountDetailsFailedState) {
                  return Column(
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
                        'Failed to get account details!',
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
                    ],
                  );
                }
                if (state is GetAccountDetailsCompletedState) {
                  user = state.user;

                  return ListView(
                    padding: const EdgeInsets.only(top: 20.0),
                    shrinkWrap: true,
                    children: <Widget>[
                      //profile image
                      Center(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: size.width * 0.25,
                              width: size.width * 0.25,
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
                              child: user.profileImageUrl.isEmpty &&
                                      selectedProfileImage == null
                                  ? Icon(
                                      Icons.person,
                                      size: 50.0,
                                    )
                                  : selectedProfileImage != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          child:
                                              Image.file(selectedProfileImage),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                'assets/icons/icon_person.png',
                                            placeholderScale: 0.5,
                                            imageErrorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(
                                              Icons.person,
                                              size: 50.0,
                                            ),
                                            image: user.profileImageUrl,
                                            fit: BoxFit.cover,
                                            fadeInDuration:
                                                Duration(milliseconds: 250),
                                            fadeInCurve: Curves.easeInOut,
                                            fadeOutDuration:
                                                Duration(milliseconds: 150),
                                            fadeOutCurve: Curves.easeInOut,
                                          ),
                                        ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Material(
                                  color: Theme.of(context).primaryColor,
                                  child: InkWell(
                                    splashColor: Colors.white.withOpacity(0.5),
                                    onTap: () {
                                      //TODO: take user to edit
                                      cropImage(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      width: 30.0,
                                      height: 30.0,
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: nameController,
                                textAlignVertical: TextAlignVertical.center,
                                validator: (String val) {
                                  if (val.trim().isEmpty) {
                                    return 'Full name is required';
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  name = val.trim();
                                },
                                enableInteractiveSelection: false,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  helperStyle: GoogleFonts.poppins(
                                    color: Colors.black.withOpacity(0.65),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                  errorStyle: GoogleFonts.poppins(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person,
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                    minWidth: 50.0,
                                  ),
                                  labelText: 'Full name',
                                  labelStyle: GoogleFonts.poppins(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                controller: mobileNoController,
                                textAlignVertical: TextAlignVertical.center,
                                validator: (String val) {
                                  if (val.trim().isEmpty) {
                                    return 'Mobile No. is required';
                                  } else if (val.trim().length != 10) {
                                    return 'Mobile No. is invalid';
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  mobileNo = val.trim();
                                },
                                enableInteractiveSelection: false,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.phone,
                                readOnly:
                                    widget.user.mobileNo != null ? true : false,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  helperStyle: GoogleFonts.poppins(
                                    color: Colors.black.withOpacity(0.65),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                  prefixText: Config().countryMobileNoPrefix,
                                  prefixStyle: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.5,
                                  ),
                                  errorStyle: GoogleFonts.poppins(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.phone,
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                    minWidth: 50.0,
                                  ),
                                  labelText: 'Mobile no.',
                                  labelStyle: GoogleFonts.poppins(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                controller: emailController,
                                textAlignVertical: TextAlignVertical.center,
                                validator: (String val) {
                                  if (val.trim().isEmpty) {
                                    return 'Email Address is required';
                                  }
                                  if (!RegExp(
                                          r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$")
                                      .hasMatch(val)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  email = val.trim();
                                },
                                enableInteractiveSelection: false,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                readOnly:
                                    widget.user.email != null ? true : false,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  helperStyle: GoogleFonts.poppins(
                                    color: Colors.black.withOpacity(0.65),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                  errorStyle: GoogleFonts.poppins(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.black54,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email,
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                    minWidth: 50.0,
                                  ),
                                  labelText: 'Email address',
                                  labelStyle: GoogleFonts.poppins(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: 45.0,
                        width: size.width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: FlatButton(
                          onPressed: () {
                            //change password
                            showchangePasswordConfimationDialog(size);
                          },
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.vpn_key,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Change Password',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: 45.0,
                        width: size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: FlatButton(
                          onPressed: () {
                            //update
                            updateAccountDetails();
                          },
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Text(
                            'Update Account Details',
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
          ),
        ],
      ),
    );
  }
}
