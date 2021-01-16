import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store_delivery/models/user.dart';

class ChangePasswordDialog extends StatefulWidget {
  final DeliveryUser user;

  const ChangePasswordDialog({Key key, this.user}) : super(key: key);
  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map passwordMap = Map();
  String oldPassword, newPassword;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      elevation: 5.0,
      contentPadding: EdgeInsets.all(0),
      content: Container(
        width: double.maxFinite,
        constraints: BoxConstraints.loose(size),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: Text(
                  'Change password',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        enableInteractiveSelection: false,
                        maxLines: 1,
                        obscureText: true,
                        validator: (String val) {
                          if (val.trim().isEmpty) {
                            return 'Old password is required';
                          } else {
                            if (widget.user.firstLogin) {
                              if (widget.user.password != val.trim()) {
                                return 'Old password does not match';
                              }
                            }
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          oldPassword = newValue.trim();
                        },
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
                          hintText: 'Old password',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14.0,
                            color: Colors.black54,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w400,
                          ),
                          counterStyle: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: Colors.black54,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        enableInteractiveSelection: false,
                        maxLines: 1,
                        obscureText: true,
                        validator: (String val) {
                          if (val.trim().isEmpty) {
                            return 'New password is required';
                          } else {
                            if (val.trim().length < 8) {
                              return 'Length should be more than 8 characters';
                            }
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          newPassword = newValue.trim();
                        },
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
                          hintText: 'New password',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14.0,
                            color: Colors.black54,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w400,
                          ),
                          counterStyle: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: Colors.black54,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Center(
                child: SizedBox(
                  width: size.width * 0.5,
                  child: FlatButton(
                    onPressed: () {
                      //change password
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        if (widget.user.firstLogin) {
                          if (widget.user.password == oldPassword) {}
                        }
                      }
                    },
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      'Proceed',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: size.width * 0.5,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
