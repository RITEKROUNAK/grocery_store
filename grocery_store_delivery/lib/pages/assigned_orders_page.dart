import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store_delivery/blocs/notification_bloc/notification_bloc.dart';
import 'package:grocery_store_delivery/blocs/user_bloc/user_bloc.dart';
import 'package:grocery_store_delivery/models/delivery_notification.dart';
import 'package:grocery_store_delivery/pages/assigned_orders_pages/assigned_orders.dart';
import 'package:grocery_store_delivery/pages/assigned_orders_pages/completed_orders.dart';
import 'package:grocery_store_delivery/screens/notification_screens/notification_screen.dart';
import 'package:grocery_store_delivery/widgets/assigned_order_item.dart';

class AssignedOrdersPage extends StatefulWidget {
  @override
  _AssignedOrdersPageState createState() => _AssignedOrdersPageState();
}

class _AssignedOrdersPageState extends State<AssignedOrdersPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  PageController _pageController = PageController(initialPage: 0);
  UserBloc userBloc;
  TabController _tabController;
  List<Widget> tabs;
  User firebaseUser;
  NotificationBloc notificationBloc;
  DeliveryNotification deliveryNotification;

  @override
  void initState() {
    super.initState();

    userBloc = BlocProvider.of<UserBloc>(context);
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
    userBloc.add(GetCurrentUserEvent());
    notificationBloc.add(GetAllNotificationsEvent());

    tabs = [
      Tab(
        text: 'Assigned',
      ),
      Tab(
        text: 'Completed',
      ),
    ];

    _tabController = TabController(length: 2, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 12.0),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.06),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Orders',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(
                            height: 37.0,
                          ),
                          BlocBuilder(
                            cubit: notificationBloc,
                            buildWhen: (previous, current) {
                              if (current
                                      is GetAllNotificationsInProgressState ||
                                  current is GetAllNotificationsFailedState ||
                                  current
                                      is GetAllNotificationsCompletedState ||
                                  current is GetNotificationsUpdateState) {
                                return true;
                              }
                              return false;
                            },
                            builder: (context, state) {
                              if (state is GetAllNotificationsInProgressState) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashColor:
                                          Colors.white.withOpacity(0.5),
                                      onTap: () {
                                        print('Notification');
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                        width: 38.0,
                                        height: 35.0,
                                        child: Icon(
                                          Icons.notifications,
                                          color: Colors.white,
                                          size: 26.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              if (state is GetNotificationsUpdateState) {
                                if (state.deliveryNotification != null) {
                                  if (state.deliveryNotification.notifications
                                          .length ==
                                      0) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          splashColor:
                                              Colors.white.withOpacity(0.5),
                                          onTap: () {
                                            print('Notification');
                                            //show snackbar with no notifications
                                            showSnack('No notifications found!',
                                                context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                            ),
                                            width: 38.0,
                                            height: 35.0,
                                            child: Icon(
                                              Icons.notifications,
                                              color: Colors.white,
                                              size: 26.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  deliveryNotification =
                                      state.deliveryNotification;
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Positioned(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              splashColor:
                                                  Colors.white.withOpacity(0.5),
                                              onTap: () {
                                                //TODO: temp

                                                // uploadImg();
                                                print('Notification');
                                                if (deliveryNotification
                                                    .unread) {
                                                  notificationBloc.add(
                                                    NotificationMarkReadEvent(),
                                                  );
                                                }
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        NotificationScreen(
                                                      deliveryNotification,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                ),
                                                width: 38.0,
                                                height: 35.0,
                                                child: Icon(
                                                  Icons.notifications,
                                                  color: Colors.white,
                                                  size: 26.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      deliveryNotification.unread
                                          ? Positioned(
                                              right: 4.0,
                                              top: 4.0,
                                              child: Container(
                                                height: 7.5,
                                                width: 7.5,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.amber,
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  );
                                }
                                return SizedBox();
                              }
                              return SizedBox();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Container(
                  height: 38.0,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TabBar(
                    tabs: tabs,
                    controller: _tabController,
                    onTap: (value) {
                      _pageController.animateToPage(
                        value,
                        curve: Curves.easeInOut,
                        duration: Duration(
                          milliseconds: 150,
                        ),
                      );
                    },
                    isScrollable: false,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: EdgeInsets.symmetric(horizontal: 25.0),
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    indicator: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    unselectedLabelStyle: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                    unselectedLabelColor: Colors.black45,
                    labelColor: Colors.white,
                    labelStyle: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder(
              buildWhen: (previous, current) {
                if (current is GetCurrentUserCompletedState ||
                    current is GetCurrentUserFailedState ||
                    current is GetCurrentUserInProgressState) {
                  return true;
                }
                return false;
              },
              cubit: userBloc,
              builder: (context, state) {
                if (state is GetCurrentUserInProgressState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is GetCurrentUserFailedState) {
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
                if (state is GetCurrentUserCompletedState) {
                  firebaseUser = state.firebaseUser;
                  return PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      AssignedOrders(firebaseUser),
                      CompletedOrders(firebaseUser),
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
