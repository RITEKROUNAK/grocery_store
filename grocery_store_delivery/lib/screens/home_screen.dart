import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_store_delivery/pages/assigned_orders_page.dart';
import 'package:grocery_store_delivery/pages/previous_orders_page.dart';
import 'package:grocery_store_delivery/pages/profile_page.dart';
import 'package:grocery_store_delivery/services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController(initialPage: 0);
  int _selectedPage;
  User currentUser;
  bool first;
  @override
  void initState() {
    super.initState();

    first = true;

    _selectedPage = 0;

    if (first) {
      currentUser = FirebaseAuth.instance.currentUser;

      first = false;

      print('INITIALIZING SERVICE ______________');

      FirebaseService.init(context, currentUser.uid, currentUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        // cartCountBloc.close();
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white54,
          ),
          height: Platform.isAndroid ? 60.0 : 85.0,
          width: size.width,
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 6.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      print('Home');
                      _pageController.jumpToPage(
                        0,
                      );
                      setState(() {
                        _selectedPage = 0;
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.boxOpen,
                      size: 23.0,
                      color: _selectedPage == 0
                          ? Theme.of(context).primaryColor
                          : Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      print('Previous Orders');
                      _pageController.jumpToPage(
                        1,
                      );
                      setState(() {
                        _selectedPage = 1;
                      });
                    },
                    child: Icon(
                      Icons.history,
                      size: 28.0,
                      color: _selectedPage == 1
                          ? Theme.of(context).primaryColor
                          : Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      print('Profile');
                      _pageController.jumpToPage(
                        2,
                      );
                      setState(() {
                        _selectedPage = 2;
                      });
                    },
                    child: Icon(
                      Icons.person,
                      size: 28.0,
                      color: _selectedPage == 2
                          ? Theme.of(context).primaryColor
                          : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            AssignedOrdersPage(),
            PreviousOrdersPage(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}
