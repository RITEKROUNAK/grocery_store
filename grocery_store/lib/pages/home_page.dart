import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_store/blocs/banner_bloc/banner_bloc.dart';
import 'package:grocery_store/blocs/cart_bloc/cart_bloc.dart';
import 'package:grocery_store/blocs/cart_bloc/cart_count_bloc.dart';
import 'package:grocery_store/blocs/category_bloc/category_bloc.dart';
import 'package:grocery_store/blocs/notification_bloc/notification_bloc.dart';
import 'package:grocery_store/blocs/product_bloc/product_bloc.dart';
import 'package:grocery_store/blocs/product_bloc/recommended_product_bloc.dart';
import 'package:grocery_store/blocs/product_bloc/trending_product_bloc.dart';
import 'package:grocery_store/blocs/sign_in_bloc/signin_bloc.dart';
import 'package:grocery_store/models/category.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/models/user_notification.dart';
import 'package:grocery_store/screens/all_categories_screen.dart';
import 'package:grocery_store/screens/common_all_products_screen.dart';
import 'package:grocery_store/screens/common_banner_products_screen.dart';
import 'package:grocery_store/screens/notification_screen.dart';
import 'package:grocery_store/services/firebase_service.dart';
import 'package:grocery_store/widget/all_category_item.dart';
import 'package:grocery_store/widget/shimmer_all_category_item.dart';
import 'package:grocery_store/widget/shimmer_banner_item.dart';
import 'package:grocery_store/widget/shimmer_product_list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../widget/product_list_item.dart';
import '../models/banner.dart' as prefix;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  CategoryBloc categoryBloc;
  BannerBloc bannerBloc;
  ProductBloc productBloc;
  TrendingProductBloc trendingProductBloc;
  FeaturedProductBloc featuredProductBloc;
  CartCountBloc cartCountBloc;
  SigninBloc signinBloc;
  User currentUser;
  CartBloc cartBloc;
  NotificationBloc notificationBloc;
  UserNotification userNotification;

  bool first;
  prefix.Banner banner;
  List<Category> categoryList;

  List<Product> trendingProducts;
  List<Product> featuredProducts;

  @override
  void initState() {
    super.initState();

    first = true;
    categoryBloc = BlocProvider.of<CategoryBloc>(context);
    bannerBloc = BlocProvider.of<BannerBloc>(context);
    productBloc = BlocProvider.of<ProductBloc>(context);
    trendingProductBloc = BlocProvider.of<TrendingProductBloc>(context);
    featuredProductBloc = BlocProvider.of<FeaturedProductBloc>(context);
    cartCountBloc = BlocProvider.of<CartCountBloc>(context);
    signinBloc = BlocProvider.of<SigninBloc>(context);
    cartBloc = BlocProvider.of<CartBloc>(context);
    notificationBloc = BlocProvider.of<NotificationBloc>(context);

    // categoryBloc.listen((state) {
    //   if (state is CategoryInitialState) {}
    // });

    // bannerBloc.listen((state) {
    //   print(state);
    //   if (first) {}
    // });

    // productBloc.listen((state) {
    //   print('PRODUCT STATE: $state');
    //   if (state is ProductInitial) {}
    // });

    // trendingProductBloc.listen((state) {
    //   if (state is InitialTrendingProductState) {}
    // });

    // featuredProductBloc.listen((state) {
    //   if (state is InitialFeaturedProductState) {}
    // });

    signinBloc.listen((state) {
      if (state is GetCurrentUserCompleted) {
        currentUser = state.firebaseUser;
        print(currentUser.uid);

        if (first) {
          FirebaseService.init(context, currentUser.uid, currentUser);
          cartCountBloc.add(GetCartCountEvent(currentUser.uid));
          notificationBloc.add(GetAllNotificationsEvent(currentUser.uid));
          first = false;
        }
      }
    });

    notificationBloc.listen((state) {
      print('NOTIFICATION STATE :::: $state');
    });

    signinBloc.add(GetCurrentUser());
    bannerBloc.add(LoadBannersEvent());
    categoryBloc.add(LoadCategories());
    productBloc.add(LoadTrendingProductsEvent());
    trendingProductBloc.add(LoadTrendingProductsEvent());
    featuredProductBloc.add(LoadFeaturedProductsEvent());
  }

  @override
  void dispose() {
    notificationBloc.close();
    first = true;
    super.dispose();
  }

  void showNoNotifSnack(String text) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: 8.0,
      backgroundColor: Colors.green.shade500,
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
      duration: Duration(milliseconds: 1500),
      icon: Icon(
        Icons.notification_important,
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
    return WillPopScope(
      onWillPop: () async {
        notificationBloc.close();
        return true;
      },
      child: Scaffold(
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
                        'Grocery Store',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 19.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      BlocBuilder(
                        cubit: notificationBloc,
                        buildWhen: (previous, current) {
                          if (current is GetAllNotificationsInProgressState ||
                              current is GetAllNotificationsFailedState ||
                              current is GetAllNotificationsCompletedState ||
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
                                  splashColor: Colors.white.withOpacity(0.5),
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
                            if (state.userNotification != null) {
                              if (state.userNotification.notifications.length ==
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
                                        showNoNotifSnack(
                                            'No notifications found!');
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
                              userNotification = state.userNotification;
                              return Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Positioned(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          splashColor:
                                              Colors.white.withOpacity(0.5),
                                          onTap: () {
                                            print('Notification');
                                            if (userNotification.unread) {
                                              notificationBloc.add(
                                                NotificationMarkReadEvent(
                                                    currentUser.uid),
                                              );
                                            }
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NotificationScreen(
                                                  userNotification,
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
                                  userNotification.unread
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
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.only(top: 25.0),
                shrinkWrap: false,
                children: <Widget>[
                  buildTopImageSlider(),
                  SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          'CATEGORIES',
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            print('go to category');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllCategoriesScreen(
                                  categoryList: categoryList,
                                  cartBloc: cartBloc,
                                  firebaseUser: currentUser,
                                ),
                              ),
                            );
                          },
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            'View All',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  buildCategories(size),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          'TRENDING',
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            if (trendingProducts != null &&
                                trendingProducts.length > 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommonAllProductsScreen(
                                    productList: trendingProducts,
                                    productType: 'Trending',
                                    cartBloc: cartBloc,
                                    currentUser: currentUser,
                                  ),
                                ),
                              );
                            }
                          },
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            'View All',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 280.0,
                    child: BlocBuilder(
                      cubit: trendingProductBloc,
                      builder: (context, state) {
                        if (state is LoadTrendingProductsInProgressState) {
                          return ListView.separated(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                period: Duration(milliseconds: 800),
                                baseColor: Colors.grey.withOpacity(0.5),
                                highlightColor: Colors.black.withOpacity(0.5),
                                child: Container(
                                  width: 150.0,
                                  child: ShimmerProductListItem(),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 20.0,
                              );
                            },
                          );
                        } else if (state is LoadTrendingProductsFailedState) {
                          return Center(
                            child: Text(
                              'Failed to load trending products!',
                              style: GoogleFonts.poppins(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          );
                        } else if (state
                            is LoadTrendingProductsCompletedState) {
                          trendingProducts = state.productList;
                          return ListView.separated(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: trendingProducts.length > 5
                                ? 5
                                : trendingProducts.length,
                            itemBuilder: (context, index) {
                              return ProductListItem(
                                product: trendingProducts[index],
                                cartBloc: cartBloc,
                                currentUser: currentUser,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 20.0,
                              );
                            },
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  buildBanner(1),
                  SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          'FEATURED',
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            if (featuredProducts != null &&
                                featuredProducts.length > 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommonAllProductsScreen(
                                    productList: featuredProducts,
                                    productType: 'Featured',
                                    cartBloc: cartBloc,
                                    currentUser: currentUser,
                                  ),
                                ),
                              );
                            }
                          },
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            'View All',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 280.0,
                    child: BlocBuilder(
                      cubit: featuredProductBloc,
                      builder: (context, state) {
                        if (state is LoadFeaturedProductsInProgressState) {
                          return ListView.separated(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                period: Duration(milliseconds: 800),
                                baseColor: Colors.grey.withOpacity(0.5),
                                highlightColor: Colors.black.withOpacity(0.5),
                                child: Container(
                                  width: 150.0,
                                  child: ShimmerProductListItem(),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 20.0,
                              );
                            },
                          );
                        } else if (state is LoadFeaturedProductsFailedState) {
                          return Center(
                            child: Text(
                              'Failed to load featured products!',
                              style: GoogleFonts.poppins(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          );
                        } else if (state
                            is LoadFeaturedProductsCompletedState) {
                          featuredProducts = state.productList;
                          return ListView.separated(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: featuredProducts.length > 5
                                ? 5
                                : featuredProducts.length,
                            itemBuilder: (context, index) {
                              return ProductListItem(
                                product: featuredProducts[index],
                                cartBloc: cartBloc,
                                currentUser: currentUser,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 20.0,
                              );
                            },
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  buildBanner(2),
                  SizedBox(
                    height: 40.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTopImageSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      child: BlocBuilder(
        cubit: bannerBloc,
        buildWhen: (previous, current) {
          if (current is LoadBannersInProgressState ||
              current is LoadBannersFailedState ||
              current is LoadBannersCompletedState) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is LoadBannersInProgressState) {
            return Container(
              height: 220.0,
              child: Shimmer.fromColors(
                period: Duration(milliseconds: 800),
                baseColor: Colors.grey.withOpacity(0.5),
                highlightColor: Colors.black.withOpacity(0.5),
                child: ShimmerBannerItem(),
              ),
            );
          } else if (state is LoadBannersFailedState) {
            return Container(
              height: 220.0,
              decoration: BoxDecoration(
                color: Colors.cyanAccent,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Center(
                child: Text(
                  'Failed to load image!',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          } else if (state is LoadBannersCompletedState) {
            banner = state.banner;
            List<Widget> imageWidgets = List();
            for (var banner in banner.topBanner) {
              imageWidgets.add(
                Container(
                  height: 220.0,
                  width: double.infinity,
                  child: Image.network(
                    banner,
                    fit: BoxFit.cover,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) {
                        return child;
                      }
                      return AnimatedOpacity(
                        child: child,
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                ),
              );
            }
            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: Offset(0.0, 0.0),
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlayCurve: Curves.easeInOut,
                    autoPlay: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 500),
                    autoPlayInterval: Duration(milliseconds: 3000),
                    height: 220.0,
                    initialPage: 0,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: true,
                    pauseAutoPlayOnTouch: true,
                    viewportFraction: 1.0,
                  ),
                  items: imageWidgets,
                ),
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  Widget buildBanner(int whichBanner) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: BlocBuilder(
        cubit: bannerBloc,
        buildWhen: (previous, current) {
          if (current is LoadBannersInProgressState ||
              current is LoadBannersFailedState ||
              current is LoadBannersCompletedState) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          print('BANNER STATE :: $state');
          if (state is LoadBannersInProgressState) {
            return Container(
              height: 160.0,
              child: Shimmer.fromColors(
                period: Duration(milliseconds: 800),
                baseColor: Colors.grey.withOpacity(0.5),
                highlightColor: Colors.black.withOpacity(0.5),
                child: ShimmerBannerItem(),
              ),
            );
          } else if (state is LoadBannersFailedState) {
            return Container(
              height: 160.0,
              decoration: BoxDecoration(
                color: Colors.cyanAccent,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Center(
                child: Text(
                  'Failed to load image!',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          } else if (state is LoadBannersCompletedState) {
            banner = state.banner;
            return Container(
              height: 160.0,
              decoration: BoxDecoration(
                color: whichBanner == 1
                    ? Colors.cyanAccent
                    : Colors.green.shade100,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: whichBanner == 1
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommonBannerProductsScreen(
                                cartBloc: cartBloc,
                                category: banner.middleBanner['category'],
                                currentUser: currentUser,
                              ),
                            ),
                          );
                        },
                        child: Image.network(
                          banner.middleBanner['middleBanner'],
                          fit: BoxFit.cover,
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) {
                              return child;
                            }
                            return AnimatedOpacity(
                              child: child,
                              opacity: frame == null ? 0 : 1,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                            );
                          },
                        ),
                        // child: SvgPicture.network(
                        //   banner.middleBanner['middleBanner'],
                        //   fit: BoxFit.cover,
                        //   placeholderBuilder: (context) => Shimmer.fromColors(
                        //     period: Duration(milliseconds: 800),
                        //     baseColor: Colors.grey.withOpacity(0.5),
                        //     highlightColor: Colors.black.withOpacity(0.5),
                        //     child: ShimmerBannerItem(),
                        //   ),
                        // ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommonBannerProductsScreen(
                                cartBloc: cartBloc,
                                category: banner.bottomBanner['category'],
                                currentUser: currentUser,
                              ),
                            ),
                          );
                        },
                        child: Image.network(
                          banner.bottomBanner['bottomBanner'],
                          fit: BoxFit.cover,
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) {
                              return child;
                            }
                            return AnimatedOpacity(
                              child: child,
                              opacity: frame == null ? 0 : 1,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                            );
                          },
                        ),
                        // child: SvgPicture.network(
                        //   banner.bottomBanner['bottomBanner'],
                        //   fit: BoxFit.cover,
                        //   placeholderBuilder: (context) => Shimmer.fromColors(
                        //     period: Duration(milliseconds: 800),
                        //     baseColor: Colors.grey.withOpacity(0.5),
                        //     highlightColor: Colors.black.withOpacity(0.5),
                        //     child: ShimmerBannerItem(),
                        //   ),
                        // ),
                      ),
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  Widget buildCategories(Size size) {
    return BlocBuilder(
      cubit: categoryBloc,
      buildWhen: (previous, current) {
        if (current is LoadCategoriesInProgressState ||
            current is LoadCategoriesCompletedState ||
            current is LoadCategoriesInFailedState) {
          return true;
        } else {
          return false;
        }
      },
      builder: (BuildContext context, state) {
        if (state is LoadCategoriesInProgressState ||
            state is CategoryInitialState) {
          //getting categories
          print('getting the categories');
          return Container(
            width: size.width,
            height: size.width - size.width * 0.2 - 32.0,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1 / 1.2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  period: Duration(milliseconds: 800),
                  baseColor: Colors.grey.withOpacity(0.5),
                  highlightColor: Colors.black.withOpacity(0.5),
                  child: ShimmerAllCategoryItem(),
                );
              },
            ),
          );
        } else if (state is LoadCategoriesInFailedState) {
          //failed getting categories
          print('failed to get the categories');
          return Container(
            width: size.width,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                'Faild to fetch!',
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        } else if (state is LoadCategoriesCompletedState) {
          //getting categories completed
          print(state.categories);
          categoryList = state.categories;

          return Container(
            width: size.width,
            height: categoryList.length < 3
                ? size.width - size.width * 0.5 - 32.0
                : size.width - size.width * 0.2 - 32.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              padding: const EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1 / 1.2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                return AllCategoryItem(
                  category: categoryList[index],
                  index: index,
                  cartBloc: cartBloc,
                  firebaseUser: currentUser,
                );
              },
            ),
          );
        }
        return SizedBox();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
