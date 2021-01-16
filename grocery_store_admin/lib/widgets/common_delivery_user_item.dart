import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/activated_delivery_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/active_delivery_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/all_delivery_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/deactivate_delivery_user_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/deactivated_delivery_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/inactive_delivery_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/manage_delivery_users_bloc.dart';
import 'package:ecommerce_store_admin/models/delivery_user.dart';
import 'package:ecommerce_store_admin/screens/manage_delivery_users_screen/edit_delivery_user_screen.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonDeliveryUserItem extends StatefulWidget {
  final Size size;
  final DeliveryUser user;
  final bool isChanged;
  final DeactivateDeliveryUserBloc deactivateDeliveryUserBloc;
  final AllDeliveryUsersBloc allDeliveryUsersBloc;
  final ActiveDeliveryUsersBloc activeDeliveryUsersBloc;
  final InactiveDeliveryUsersBloc inactiveDeliveryUsersBloc;
  final ActivatedDeliveryUsersBloc activatedDeliveryUsersBloc;
  final DeactivatedDeliveryUsersBloc deactivatedDeliveryUsersBloc;
  final String deliveryUserType;

  const CommonDeliveryUserItem({
    this.size,
    this.user,
    this.isChanged,
    this.deactivateDeliveryUserBloc,
    this.activatedDeliveryUsersBloc,
    this.activeDeliveryUsersBloc,
    this.allDeliveryUsersBloc,
    this.deactivatedDeliveryUsersBloc,
    this.deliveryUserType,
    this.inactiveDeliveryUsersBloc,
  });

  @override
  _CommonDeliveryUserItemState createState() => _CommonDeliveryUserItemState();
}

class _CommonDeliveryUserItemState extends State<CommonDeliveryUserItem> {
  @override
  void initState() {
    super.initState();
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

  sendToEditDeliveryUser() async {
    bool isEdited = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDeliveryUserScreen(
          deliveryUser: widget.user,
        ),
      ),
    );
    if (isEdited != null) {
      if (isEdited) {
        switch (widget.deliveryUserType) {
          case 'ALL':
            widget.allDeliveryUsersBloc.add(GetAllDeliveryUsersEvent());
            break;
          case 'ACTIVE':
            widget.activeDeliveryUsersBloc.add(GetActiveDeliveryUsersEvent());
            break;
          case 'INACTIVE':
            widget.inactiveDeliveryUsersBloc
                .add(GetInactiveDeliveryUsersEvent());
            break;
          case 'ACTIVATED':
            widget.activatedDeliveryUsersBloc
                .add(GetActivatedDeliveryUsersEvent());
            break;
          case 'DEACTIVATED':
            widget.deactivatedDeliveryUsersBloc
                .add(GetDeactivatedDeliveryUsersEvent());
            break;
          default:
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
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
                width: widget.size.width * 0.15,
                height: widget.size.width * 0.15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11.0),
                ),
                child: widget.user.profileImageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(11.0),
                        child: Center(
                          child: FadeInImage.assetNetwork(
                            placeholder:
                                'assets/icons/category_placeholder.png',
                            image: widget.user.profileImageUrl,
                            placeholderErrorBuilder:
                                (context, error, stackTrace) {
                              return Image.asset(
                                  'assets/icons/icon_person.png');
                            },
                            fit: BoxFit.cover,
                            fadeInDuration: Duration(milliseconds: 250),
                            fadeInCurve: Curves.easeInOut,
                            fadeOutDuration: Duration(milliseconds: 150),
                            fadeOutCurve: Curves.easeInOut,
                          ),
                        ),
                      )
                    : Image.asset('assets/icons/icon_person.png'),
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
                      '${widget.user.name}',
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
                      widget.user.mobileNo.isNotEmpty
                          ? 'Mobile no.: ${widget.user.mobileNo}'
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
            'Account status: ${widget.user.accountStatus}',
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
            widget.user.email.isNotEmpty
                ? 'Email: ${widget.user.email}'
                : 'Email: NA',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.75),
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          widget.user.password != null
              ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Temporary password: ${widget.user.password}',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.75),
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                )
              : SizedBox(),
          SizedBox(
            height: 5.0,
          ),
          Text(
            widget.user.activated ? 'Account activated' : 'Account deactivated',
            style: GoogleFonts.poppins(
              color: widget.user.activated
                  ? Colors.green.shade600
                  : Colors.red.shade600,
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
                    sendToEditDeliveryUser();
                  },
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  splashColor: Colors.white.withOpacity(0.4),
                  child: Text(
                    'Edit Details',
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
              widget.user.activated
                  ? Expanded(
                      child: FlatButton(
                        onPressed: () {
                          // //TODO: temp disabled
                          // showSnack(
                          //     'You\'re not a Primary admin.\nAction not allowed!',
                          //     context);

                          //block and unblock
                          widget.deactivateDeliveryUserBloc.add(
                              DeactivateDeliveryUserEvent(widget.user.uid));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                              width: 1.0,
                              color: Colors.black.withOpacity(0.4),
                              style: BorderStyle.solid),
                        ),
                        child: Text(
                          'Deactivate User',
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
                          widget.deactivateDeliveryUserBloc
                              .add(ActivateDeliveryUserEvent(widget.user.uid));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                              width: 1.0,
                              color: Colors.black.withOpacity(0.4),
                              style: BorderStyle.solid),
                        ),
                        child: Text(
                          'Activate User',
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
