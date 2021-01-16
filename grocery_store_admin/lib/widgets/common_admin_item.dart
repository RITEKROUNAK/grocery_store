import 'package:ecommerce_store_admin/blocs/my_account_bloc/all_admins_bloc.dart';
import 'package:ecommerce_store_admin/blocs/my_account_bloc/deactivate_admin_bloc.dart';
import 'package:ecommerce_store_admin/blocs/my_account_bloc/my_account_bloc.dart';
import 'package:ecommerce_store_admin/models/admin.dart';
import 'package:ecommerce_store_admin/screens/my_account_screen/edit_admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CommonAdminItem extends StatefulWidget {
  final Size size;
  final Admin admin;
  final AllAdminsBloc allAdminsBloc;
  final DeactivateAdminBloc deactivateAdminBloc;

  const CommonAdminItem(
      {Key key,
      this.size,
      this.admin,
      this.allAdminsBloc,
      this.deactivateAdminBloc})
      : super(key: key);

  @override
  _CommonAdminItemState createState() => _CommonAdminItemState();
}

class _CommonAdminItemState extends State<CommonAdminItem> {
  sendToEditAdmin() async {
    bool isEdited = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAdminScreen(
          admin: widget.admin,
        ),
      ),
    );
    if (isEdited != null) {
      if (isEdited) {
        widget.allAdminsBloc.add(GetAllAdminsEvent());
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
          Text(
            '${widget.admin.name}',
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
            widget.admin.mobileNo.isNotEmpty
                ? 'Mobile no.: ${widget.admin.mobileNo}'
                : 'Mobile no.: NA',
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.75),
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          // SizedBox(
          //   height: 8.0,
          // ),
          // Text(
          //   'Account status: ${admin.accountStatus}',
          //   style: GoogleFonts.poppins(
          //     color: Colors.black.withOpacity(0.75),
          //     fontSize: 14.5,
          //     fontWeight: FontWeight.w500,
          //     letterSpacing: 0.3,
          //   ),
          // ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            widget.admin.email.isNotEmpty
                ? 'Email: ${widget.admin.email}'
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
          SizedBox(
            height: 5.0,
          ),
          Text(
            widget.admin.password.isNotEmpty
                ? 'Password: ${widget.admin.password}'
                : 'Password: NA',
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
            widget.admin.primaryAdmin
                ? 'Primary admin: YES'
                : 'Primary admin: NO',
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
            'Last updated: ${new DateFormat('dd MMM yyyy, hh:mm a').format(widget.admin.timestamp.toDate())}',
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
            widget.admin.activated
                ? 'Account activated'
                : 'Account deactivated',
            style: GoogleFonts.poppins(
              color: widget.admin.activated
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
                    sendToEditAdmin();
                  },
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  splashColor: Colors.white.withOpacity(0.4),
                  child: Text(
                    'Edit Admin',
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
              widget.admin.activated
                  ? Expanded(
                      child: FlatButton(
                        onPressed: () {
                          //block and unblock
                          if (widget.admin.primaryAdmin) {
                            //cant deactivate
                          } else {
                            //deactivate
                            widget.deactivateAdminBloc
                                .add(DeactivateAdminEvent(widget.admin.uid));
                            setState(() {
                              widget.admin.activated = false;
                            });
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                              width: 1.0,
                              color: Colors.black.withOpacity(0.4),
                              style: BorderStyle.solid),
                        ),
                        child: Text(
                          'Deactivate',
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
                          //block and unblock
                          if (widget.admin.primaryAdmin) {
                            //cant activate
                          } else {
                            //activate
                            widget.deactivateAdminBloc
                                .add(ActivateAdminEvent(widget.admin.uid));
                            setState(() {
                              widget.admin.activated = true;
                            });
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                              width: 1.0,
                              color: Colors.black.withOpacity(0.4),
                              style: BorderStyle.solid),
                        ),
                        child: Text(
                          'Activate',
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
