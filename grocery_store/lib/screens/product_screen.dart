import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_store/blocs/cart_bloc/cart_bloc.dart';
import 'package:grocery_store/blocs/cart_bloc/cart_count_bloc.dart';
import 'package:grocery_store/blocs/product_bloc/increment_view_bloc.dart';
import 'package:grocery_store/blocs/product_bloc/product_bloc.dart';
import 'package:grocery_store/blocs/product_bloc/report_product_bloc.dart';
import 'package:grocery_store/blocs/product_bloc/similar_product_bloc.dart';
import 'package:grocery_store/blocs/product_bloc/wishlist_product_bloc.dart';
import 'package:grocery_store/blocs/sign_in_bloc/signin_bloc.dart';
import 'package:grocery_store/config/config.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/widget/product_detail_item.dart';
import 'package:grocery_store/widget/product_list_item.dart';
import 'package:grocery_store/widget/report_product_dialog.dart';
import 'package:grocery_store/widget/shimmer_product_detail.dart';
import 'package:grocery_store/widget/shimmer_product_list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ProductScreen extends StatefulWidget {
  final String productId;
  ProductScreen({this.productId});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ProductBloc productBloc;
  SimilarProductBloc similarProductBloc;
  CartBloc cartBloc;
  SigninBloc signinBloc;
  CartCountBloc cartCountBloc;
  User _currentUser;
  WishlistProductBloc wishlistProductBloc;
  IncrementViewBloc incrementViewBloc;
  ReportProductBloc reportProductBloc;

  Product _product;
  List<Product> _similarProducts;
  int cartCount;

  bool isReporting;

  @override
  void initState() {
    super.initState();

    print('PRODUCT ID :: ${widget.productId}');

    isReporting = false;

    productBloc = BlocProvider.of<ProductBloc>(context);
    similarProductBloc = BlocProvider.of<SimilarProductBloc>(context);
    cartBloc = BlocProvider.of<CartBloc>(context);
    signinBloc = BlocProvider.of<SigninBloc>(context);
    cartCountBloc = BlocProvider.of<CartCountBloc>(context);
    wishlistProductBloc = BlocProvider.of<WishlistProductBloc>(context);
    incrementViewBloc = BlocProvider.of<IncrementViewBloc>(context);
    reportProductBloc = BlocProvider.of<ReportProductBloc>(context);

    productBloc.add(LoadProductEvent(widget.productId));
    signinBloc.add(GetCurrentUser());
    incrementViewBloc.add(IncrementViewEvent(widget.productId));

    signinBloc.listen((state) {
      print('Current User :: $state');
      if (state is GetCurrentUserCompleted) {
        _currentUser = state.firebaseUser;
      }
      if (state is GetCurrentUserFailed) {
        //failed to get current user
      }
      if (state is GetCurrentUserInProgress) {
        //getting current user
      }
    });

    cartBloc.add(InitializeCartEvent());
    wishlistProductBloc.add(InitializeWishlistEvent());

    wishlistProductBloc.listen((state) {
      //TODO: add to wishlist and remove from wishlist
      // if (state is AddToWishlistCompletedState) {
      //   showSnack('Added to wishlist');
      //   // wishlistProductBloc.close();
      // }
      if (state is AddToWishlistFailedState) {
        showSnack('Failed adding to wishlist', context);
      }
      if (state is AddToWishlistInProgressState) {
        showSnack('Added to wishlist', context);
      }
    });

    reportProductBloc.listen((state) {
      print('REPORT BLOC: $state');

      if (state is ReportProductInProgressState) {
        //show updating dialog
        isReporting = true;
        Navigator.pop(context);
        showReportingProductDialog();
      }
      if (state is ReportProductFailedState) {
        //show failed dialog
        if (isReporting = false) {
          isReporting = false;
          Navigator.pop(context);
          showReportSnack('Failed to report the product!', 'FAILED', context);
        }
      }
      if (state is ReportProductCompletedState) {
        //show reported dialog
        if (isReporting) {
          isReporting = false;
          Navigator.pop(context);
          showReportSnack(
              'Reported the product successfully', 'REPORTED', context);
        }
      }
    });
  }

  void addToCart() {
    print('adding to cart');
    if (_currentUser.uid != null) {
      if (_product.inStock) {
        cartBloc.add(AddToCartEvent(
          _product.id,
          _currentUser.uid,
        ));
      } else {
        showReportSnack('Product is Out of stock!', 'FAILED', context);
      }
    } else {
      //not logged in

    }
  }

  void showReportingProductDialog() {
    showDialog(
      context: context,
      child: AlertDialog(
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              width: 10.0,
            ),
            Text(
              'Reporting the product',
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: GoogleFonts.poppins(
                color: Colors.black.withOpacity(0.9),
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Future showReportProductPopup() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ReportProductDialog(
          productId: widget.productId,
          reportProductBloc: reportProductBloc,
          uid: _currentUser.uid,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/cart');
            },
            child: BlocBuilder(
              cubit: cartCountBloc,
              builder: (context, state) {
                if (state is CartCountUpdateState) {
                  cartCount = state.cartCount;
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Icon(
                            Icons.shopping_cart,
                            size: 25.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      cartCount > 0
                          ? Positioned(
                              right: 3.0,
                              top: 5.0,
                              child: Container(
                                height: 16.0,
                                width: 16.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  color: Colors.amber,
                                ),
                                child: Text(
                                  '$cartCount',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  );
                }
                return Icon(
                  Icons.shopping_cart,
                  size: 25.0,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: PopupMenuButton(
              offset: Offset(0, 50.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 1) {
                  showReportProductPopup();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.report,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'Report product',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 16.0,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              BlocBuilder(
                cubit: productBloc,
                buildWhen: (previous, current) {
                  if (current is LoadProductCompletedState ||
                      current is LoadProductFailedState ||
                      current is LoadProductInProgressState) {
                    return true;
                  } else {
                    return false;
                  }
                },
                builder: (context, state) {
                  print('ProductEvent State: $state');
                  if (state is ProductInitial) {
                    return SizedBox();
                  } else if (state is LoadProductInProgressState) {
                    return Shimmer.fromColors(
                      period: Duration(milliseconds: 1000),
                      baseColor: Colors.grey.withOpacity(0.5),
                      highlightColor: Colors.black.withOpacity(0.5),
                      child: ShimmerProductDetail(),
                    );
                  } else if (state is LoadProductFailedState) {
                    return Column(
                      children: <Widget>[
                        SizedBox(
                          height: 15.0,
                        ),
                        SvgPicture.asset(
                          'assets/banners/retry.svg',
                          height: 150.0,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          height: 75.0,
                          width: size.width * 0.7,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 16.0),
                          child: FlatButton(
                            onPressed: () {
                              //TODO: fix this
                              // productBloc.add(LoadSimilarProductsEvent(
                              //     category: 'Fruits & Vegetables',
                              //     subCategory: 'Fruits'));
                              // productBloc
                              //     .add(LoadProductEvent(widget.productId));
                            },
                            color: Colors.lightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.rotate_right,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  'Retry loading',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state is LoadProductCompletedState) {
                    _product = state.product;
                    similarProductBloc.add(
                      LoadSimilarProductsEvent(
                        category: _product.category,
                        subCategory: _product.subCategory,
                        productId: _product.id,
                      ),
                    );

                    return ProductDetailItem(
                      product: _product,
                      currentUser: _currentUser,
                    );
                  } else
                    return Shimmer.fromColors(
                      period: Duration(milliseconds: 1000),
                      baseColor: Colors.grey.withOpacity(0.5),
                      highlightColor: Colors.black.withOpacity(0.5),
                      child: ShimmerProductDetail(),
                    );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(),
              ),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      'Similar Products',
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              BlocBuilder(
                cubit: similarProductBloc,
                builder: (context, state) {
                  print('SIMILAR PRODUCTS :: $state');
                  if (state is LoadSimilarProductsInProgressState) {
                    return Container(
                      height: 280.0,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            period: Duration(milliseconds: 800),
                            baseColor: Colors.grey.withOpacity(0.5),
                            highlightColor: Colors.black.withOpacity(0.5),
                            child: ShimmerProductListItem(),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 20.0,
                          );
                        },
                      ),
                    );
                  } else if (state is LoadSimilarProductsFailedState) {
                    return Center(
                      child: Text(
                        'Failed to load similar products!',
                        style: GoogleFonts.poppins(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    );
                  } else if (state is LoadSimilarProductsCompletedState) {
                    if (state.productList.length == 0) {
                      return Center(
                        child: Text(
                          'No similar products found!',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      );
                    }
                    _similarProducts = state.productList;
                    return Container(
                      height: 280.0,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _similarProducts.length > 5
                            ? 5
                            : _similarProducts.length,
                        itemBuilder: (context, index) {
                          return ProductListItem(
                            product: _similarProducts[index],
                            cartBloc: cartBloc,
                            currentUser: _currentUser,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 20.0,
                          );
                        },
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
              SizedBox(
                height: 95.0,
              ),
            ],
          ),
          buildAddToCart(size, context),
        ],
      ),
    );
  }

  Widget buildAddToCart(Size size, BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        height: 80.0,
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white70,
              Colors.white54,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: BlocBuilder(
          cubit: cartBloc,
          builder: (context, state) {
            if (state is AddToCartInProgressState) {
              return FlatButton(
                onPressed: () {
                  //temporary
                },
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 25.0,
                      width: 25.0,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 3.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.black38),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      'Adding to cart',
                      style: GoogleFonts.poppins(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }
            if (state is AddToCartFailedState) {
              //create snack
            }
            if (state is AddToCartCompletedState) {
              //create snack
              // showSnack();
              return FlatButton(
                onPressed: () {
                  //temporary
                },
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      'Added to cart',
                      style: GoogleFonts.poppins(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }
            return FlatButton(
              onPressed: () {
                //add to cart
                addToCart();
              },
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    'Add to cart',
                    style: GoogleFonts.poppins(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void showSnack(String text, BuildContext context) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: 8.0,
      backgroundColor: Colors.green,
      animationDuration: Duration(milliseconds: 350),
      isDismissible: true,
      duration: Duration(milliseconds: 2500),
      icon: Icon(
        Icons.favorite_border,
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

  void showReportSnack(String text, String type, BuildContext context) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: 8.0,
      backgroundColor: type == 'FAILED' ? Colors.red : Colors.green,
      animationDuration: Duration(milliseconds: 350),
      isDismissible: true,
      duration: Duration(milliseconds: 2500),
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
}
