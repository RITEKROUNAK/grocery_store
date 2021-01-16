import 'package:ecommerce_store_admin/blocs/manage_users_bloc/block_user_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_users_bloc/manage_users_bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_users_bloc/users_order_bloc.dart';
import 'package:ecommerce_store_admin/models/order.dart';
import 'package:ecommerce_store_admin/models/user.dart';
import 'package:ecommerce_store_admin/widgets/address_item.dart';
import 'package:ecommerce_store_admin/widgets/common_order_item.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/delete_confirm_dialog.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/processing_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonUserDetailsScreen extends StatefulWidget {
  final GroceryUser user;
  CommonUserDetailsScreen({this.user});

  @override
  _CommonUserDetailsScreenState createState() =>
      _CommonUserDetailsScreenState();
}

class _CommonUserDetailsScreenState extends State<CommonUserDetailsScreen> {
  UsersOrderBloc usersOrderBloc;
  List<Order> orders;
  BlockUserBloc blockUserBloc;
  bool isPerformingBlockUnblock;
  @override
  void initState() {
    super.initState();

    isPerformingBlockUnblock = false;

    usersOrderBloc = BlocProvider.of<UsersOrderBloc>(context);
    blockUserBloc = BlocProvider.of<BlockUserBloc>(context);

    usersOrderBloc.add(GetUsersOrderManageUsersEvent(widget.user.orders));

    blockUserBloc.listen((state) {
      if (state is BlockUserCompletedState ||
          state is UnblockUserCompletedState) {
        //refresh
        if (isPerformingBlockUnblock) {
          Navigator.pop(context);
          setState(() {
            isPerformingBlockUnblock = false;
            widget.user.isBlocked = !widget.user.isBlocked;
          });
        }
      }
      if (state is BlockUserFailedState || state is UnblockUserFailedState) {
        if (isPerformingBlockUnblock) {
          Navigator.pop(context);
          isPerformingBlockUnblock = false;
          showSnack('Failed to block the user!', context);
        }
      }
      if (state is BlockUserInProgressState ||
          state is UnblockUserInProgressState) {
        if (isPerformingBlockUnblock) {
          showUpdatingDialog('Blocking the user..\nPlease wait!');
        }
      }
    });
  }

  showUpdatingDialog(String message) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProcessingDialog(
          message: message,
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

  showConfirmationPopup(String type) async {
    bool res = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return DeleteConfirmDialog(
          message: type == 'BLOCK'
              ? 'Do you want to block this user?'
              : 'Do you want to unblock this user?',
        );
      },
    );

    if (res == true) {
      //move ahead
      if (type == 'BLOCK') {
        blockUserBloc.add(BlockUserManageUsersEvent(widget.user.uid));
      } else {
        blockUserBloc.add(UnblockUserManageUsersEvent(widget.user.uid));
      }
      isPerformingBlockUnblock = true;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      'User Details',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 19.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Center(
                  child: Container(
                    width: size.width * 0.3,
                    height: size.width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(500.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(500.0),
                      child: Center(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/icons/category_placeholder.png',
                          image: widget.user.profileImageUrl,
                          fit: BoxFit.cover,
                          fadeInDuration: Duration(milliseconds: 250),
                          fadeInCurve: Curves.easeInOut,
                          fadeOutDuration: Duration(milliseconds: 150),
                          fadeOutCurve: Curves.easeInOut,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15.0),
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
                        'USER INFO',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Name: ',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.75),
                              fontSize: 15.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            '${widget.user.name}',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
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
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Account status: ',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.75),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            '${widget.user.accountStatus}',
                            style: GoogleFonts.poppins(
                              color: widget.user.accountStatus == 'Active'
                                  ? Colors.green.shade600
                                  : Colors.red.shade600,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
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
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        'User id: ${widget.user.uid}',
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
                        'Cart items: ${widget.user.cart.length}',
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
                        widget.user.isBlocked
                            ? 'Account blocked: Yes'
                            : 'Account blocked: No',
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
                          widget.user.isBlocked
                              ? Expanded(
                                  child: FlatButton(
                                    onPressed: () {
                                      //TODO: unblock user
                                      showConfirmationPopup('UNBLOCK');
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
                                      //TODO: block user
                                      showConfirmationPopup('BLOCK');
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
                ),
                SizedBox(
                  height: 16.0,
                ),
                Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15.0),
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
                        'ADDRESSES',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(),
                      SizedBox(
                        height: 5.0,
                      ),
                      widget.user.address.length > 0
                          ? ListView.separated(
                              padding: const EdgeInsets.all(0.0),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            widget.user.address[index].landmark
                                                    .isEmpty
                                                ? '${widget.user.address[index].houseNo}, ${widget.user.address[index].addressLine1},\n${widget.user.address[index].addressLine2},\n${widget.user.address[index].city},  \n${widget.user.address[index].state}, ${widget.user.address[index].country} - ${widget.user.address[index].pincode}'
                                                : '${widget.user.address[index].houseNo}, ${widget.user.address[index].addressLine1},\n${widget.user.address[index].addressLine2},\n${widget.user.address[index].landmark}, ${widget.user.address[index].city},  \n${widget.user.address[index].state}, ${widget.user.address[index].country} - ${widget.user.address[index].pincode}',
                                            style: GoogleFonts.poppins(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    widget.user.defaultAddress ==
                                            index.toString()
                                        ? Text(
                                            'Default address',
                                            style: GoogleFonts.poppins(
                                              color: Colors.blue.shade900,
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.3,
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) => Divider(),
                              itemCount: widget.user.address.length,
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'No addresses found',
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'ORDERS',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                BlocBuilder(
                  cubit: usersOrderBloc,
                  buildWhen: (previous, current) {
                    if (current is GetUsersOrderCompletedState ||
                        current is GetUsersOrderInProgressState ||
                        current is GetUsersOrderFailedState) {
                      return true;
                    }
                    return false;
                  },
                  builder: (context, state) {
                    if (state is GetUsersOrderInProgressState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );

                      //TODO: ADD SHIMMER
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        itemBuilder: (context, index) {
                          // return Shimmer.fromColors(
                          //   period: Duration(milliseconds: 800),
                          //   baseColor: Colors.grey.withOpacity(0.5),
                          //   highlightColor: Colors.black.withOpacity(0.5),
                          //   child: ShimmerUserItem(size: size),
                          // );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 15.0,
                          );
                        },
                        itemCount: 5,
                      );
                    }
                    if (state is GetUsersOrderFailedState) {
                      return Center(
                        child: Text(
                          'Failed to load orders!',
                          style: GoogleFonts.poppins(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      );
                    }
                    if (state is GetUsersOrderCompletedState) {
                      if (state.orders != null) {
                        orders = List();

                        if (state.orders.length == 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/images/empty_prod.svg',
                                width: size.width * 0.6,
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Text(
                                'No orders found!',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                                style: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.7),
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
                        } else {
                          orders = state.orders;

                          return ListView.separated(
                            shrinkWrap: true,
                            padding:
                                const EdgeInsets.only(bottom: 16.0, top: 16.0),
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return CommonOrderItem(
                                size: size,
                                order: orders[index],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 16.0,
                              );
                            },
                            itemCount: orders.length,
                          );
                        }
                      }
                    }
                    return SizedBox();
                  },
                ),
                SizedBox(
                  height: 25.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
