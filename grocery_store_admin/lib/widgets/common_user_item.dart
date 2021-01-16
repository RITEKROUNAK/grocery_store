import 'package:ecommerce_store_admin/blocs/manage_users_bloc/block_user_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_users_bloc/manage_users_bloc.dart';
import 'package:ecommerce_store_admin/models/user.dart';
import 'package:ecommerce_store_admin/screens/manage_users_screens/common_user_details_screen.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonUserItem extends StatelessWidget {
  final Size size;
  final GroceryUser user;
  final bool isChanged;
  final BlockUserBloc blockUserBloc;

  const CommonUserItem(
      {Key key, this.size, this.user, this.isChanged, this.blockUserBloc})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
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

    return Container(
      width: size.width,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: size.width * 0.15,
                height: size.width * 0.15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11.0),
                  child: Center(
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/icons/category_placeholder.png',
                      image: user.profileImageUrl,
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
                width: 12.0,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '${user.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      user.mobileNo.isNotEmpty
                          ? 'Mobile no.: ${user.mobileNo}'
                          : 'Mobile no.: NA',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.75),
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'Account status: ${user.accountStatus}',
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.75),
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            user.email.isNotEmpty ? 'Email: ${user.email}' : 'Email: NA',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.75),
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            'Cart items: ${user.cart.length}',
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.75),
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            user.isBlocked ? 'Account blocked: Yes' : 'Account blocked: No',
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.75),
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  onPressed: () {
                    // //TODO: temp disabled
                    // showSnack(
                    //     'You\'re not a Primary admin.\nAction not allowed!',
                    //     context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommonUserDetailsScreen(
                          user: user,
                        ),
                      ),
                    );
                  },
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  splashColor: Colors.white.withOpacity(0.4),
                  child: Text(
                    'View Details',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              user.isBlocked
                  ? Expanded(
                      child: FlatButton(
                        onPressed: () {
                          // //TODO: temp disabled
                          // showSnack(
                          //     'You\'re not a Primary admin.\nAction not allowed!',
                          //     context);

                          //block and unblock
                          blockUserBloc
                              .add(UnblockUserManageUsersEvent(user.uid));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                              width: 1.0,
                              color: Colors.black.withOpacity(0.4),
                              style: BorderStyle.solid),
                        ),
                        child: Text(
                          'Unblock User',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: FlatButton(
                        onPressed: () {
                          // //TODO: temp disabled
                          // showSnack(
                          //     'You\'re not a Primary admin.\nAction not allowed!',
                          //     context);

                          //block and unblock

                          blockUserBloc
                              .add(BlockUserManageUsersEvent(user.uid));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                              width: 1.0,
                              color: Colors.black.withOpacity(0.4),
                              style: BorderStyle.solid),
                        ),
                        child: Text(
                          'Block User',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }
}
