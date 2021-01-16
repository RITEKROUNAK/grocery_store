import 'package:grocery_store/blocs/cart_bloc/cart_bloc.dart';
import 'package:grocery_store/blocs/search_bloc/search_bloc.dart';
import 'package:grocery_store/blocs/sign_in_bloc/signin_bloc.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/widget/product_list_item.dart';
import 'package:grocery_store/widget/shimmer_product_list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  SearchBloc searchBloc;
  String previousLetter, currentLetter;
  List<Product> productsList;
  List<Product> filteredList;
  CartBloc cartBloc;
  User currentUser;
  SigninBloc signinBloc;

  @override
  void initState() {
    super.initState();

    searchBloc = BlocProvider.of<SearchBloc>(context);
    cartBloc = BlocProvider.of<CartBloc>(context);
    signinBloc = BlocProvider.of<SigninBloc>(context);
    // searchBloc.add(FirstSearchEvent());

    signinBloc.listen((state) {
      if (state is GetCurrentUserCompleted) {
        currentUser = state.firebaseUser;
        print(currentUser.uid);
      }
    });
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
                    left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
                child: Container(
                  height: 43.0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 0.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    enableInteractiveSelection: false,
                    onChanged: (value) {
                      if (value.length > 0) {
                        if (productsList != null) {
                          searchBloc.add(NewSearchEvent(
                              value.toLowerCase(), productsList));
                        }
                      }
                    },
                    onSubmitted: (value) {
                      if (value.trim().length > 0) {
                        if (productsList != null) {
                        } else {
                          searchBloc.add(FirstSearchEvent(value.toLowerCase()));
                        }
                      }
                    },
                    style: GoogleFonts.poppins(
                      fontSize: 14.5,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black54,
                        size: 20.0,
                      ),
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14.5,
                        color: Colors.black54,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder(
              cubit: searchBloc,
              buildWhen: (previous, current) {
                if (current is FirstSearchCompletedState ||
                    current is FirstSearchFailedState ||
                    current is FirstSearchInProgressState ||
                    current is NewSearchCompletedState ||
                    current is NewSearchFailedState ||
                    current is NewSearchInProgressState) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is FirstSearchInProgressState ||
                    state is NewSearchInProgressState) {
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
                if (state is FirstSearchFailedState ||
                    state is NewSearchFailedState) {
                  return Center(
                    child: Text(
                      'Failed to search products!',
                      style: GoogleFonts.poppins(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  );
                }
                if (state is NewSearchCompletedState ||
                    state is FirstSearchCompletedState) {
                  if (state.filteredList.length == 0) {
                    return ListView(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        SvgPicture.asset(
                          'assets/images/empty_prod.svg',
                          width: size.width * 0.6,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Center(
                          child: Text(
                            'No products found!',
                            style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  if (state is FirstSearchCompletedState) {
                    productsList = state.searchList;
                    filteredList = state.filteredList;
                  }
                  if (state is NewSearchCompletedState) {
                    filteredList = state.filteredList;
                  }

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1 / 1.6,
                      crossAxisSpacing: 16.0,
                    ),
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 35.0, top: 16.0),
                    itemCount: filteredList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return ProductListItem(
                        product: filteredList[index],
                        cartBloc: cartBloc,
                        currentUser: currentUser,
                      );
                    },
                  );
                } else {
                  return ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      SvgPicture.asset(
                        'assets/banners/search_banner.svg',
                        width: size.width * 0.6,
                      ),
                    ],
                  );
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
