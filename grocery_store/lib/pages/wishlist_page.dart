import 'package:grocery_store/blocs/cart_bloc/cart_bloc.dart';
import 'package:grocery_store/blocs/product_bloc/product_bloc.dart';
import 'package:grocery_store/blocs/product_bloc/wishlist_product_bloc.dart';
import 'package:grocery_store/blocs/sign_in_bloc/signin_bloc.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/widget/product_list_item.dart';
import 'package:grocery_store/widget/shimmer_product_list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage>
    with AutomaticKeepAliveClientMixin<WishlistPage> {
  WishlistProductBloc wishlistProductBloc;
  List<Product> wishlistProducts;
  CartBloc cartBloc;
  User currentUser;
  SigninBloc signinBloc;

  @override
  void initState() {
    super.initState();

    wishlistProductBloc = BlocProvider.of<WishlistProductBloc>(context);
    cartBloc = BlocProvider.of<CartBloc>(context);
    signinBloc = BlocProvider.of<SigninBloc>(context);

    signinBloc.listen((state) {
      if (state is GetCurrentUserCompleted) {
        currentUser = state.firebaseUser;
        print(currentUser.uid);

        wishlistProductBloc.add(LoadWishlistProductEvent(currentUser.uid));
      }
    });

    wishlistProductBloc.listen((state) {
      if (state is AddToWishlistCompletedState ||
          state is RemoveFromWishlistCompletedState) {
        wishlistProductBloc.add(LoadWishlistProductEvent(currentUser.uid));
      }
    });

    signinBloc.add(GetCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      'Wishlist',
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
            child: BlocBuilder(
              cubit: wishlistProductBloc,
              buildWhen: (previous, current) {
                if (current is LoadWishlistProductCompletedState ||
                    current is LoadWishlistProductFailedState ||
                    current is LoadWishlistProductInProgressState) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is LoadWishlistProductInProgressState) {
                  return GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1 / 1.6,
                      crossAxisSpacing: 16.0,
                    ),
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 35.0, top: 16.0),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        period: Duration(milliseconds: 800),
                        baseColor: Colors.grey.withOpacity(0.5),
                        highlightColor: Colors.black.withOpacity(0.5),
                        child: ShimmerProductListItem(),
                      );
                    },
                  );
                }
                if (state is LoadWishlistProductFailedState) {
                  return Center(
                    child: Text(
                      'Failed to load wishlisted products!',
                      style: GoogleFonts.poppins(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  );
                }
                if (state is LoadWishlistProductCompletedState) {
                  if (state.productList.length == 0) {
                    return SizedBox();
                  }
                  wishlistProducts = state.productList;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1 / 1.6,
                      crossAxisSpacing: 16.0,
                    ),
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 35.0, top: 16.0),
                    itemCount: wishlistProducts.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return ProductListItem(
                        product: wishlistProducts[index],
                        cartBloc: cartBloc,
                        currentUser: currentUser,
                      );
                    },
                  );
                } else {
                  return SizedBox();
                }
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
