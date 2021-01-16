import 'package:grocery_store/blocs/cart_bloc/cart_bloc.dart';
import 'package:grocery_store/blocs/product_bloc/category_products_bloc.dart';
import 'package:grocery_store/blocs/product_bloc/product_bloc.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/widget/product_list_item.dart';
import 'package:grocery_store/widget/shimmer_product_list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class SubCategoriesScreen extends StatefulWidget {
  final List subCategories;
  final int selectedCategory;
  final String category;
  final CartBloc cartBloc;
  final User firebaseUser;

  const SubCategoriesScreen({
    this.subCategories,
    this.selectedCategory,
    this.category,
    this.cartBloc,
    this.firebaseUser,
  });

  @override
  _SubCategoriesScreenState createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Widget> tabs;
  List<Widget> tabViews;
  CategoryProductsBloc categoryProductsBloc;
  List<Product> productList;

  @override
  void initState() {
    super.initState();

    categoryProductsBloc = BlocProvider.of<CategoryProductsBloc>(context);

    print(widget.subCategories);

    tabs = List();
    tabViews = List();

    _tabController =
        TabController(length: widget.subCategories.length, vsync: this);

    //TODO: 1) get all this category products
    //TODO: 2) then categorize them into subcategories and add to specific tab views

    categoryProductsBloc
        .add(LoadCategoryProductsEvent(category: widget.category));

    for (var subCategory in widget.subCategories) {
      tabs.add(
        Tab(
          text: subCategory['subCategoryName'],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('AGAIN BUILT');
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
                            widget.category,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
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
                    isScrollable: true,
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
          SizedBox(
            height: 15.0,
          ),
          Expanded(
            child: BlocBuilder(
              cubit: categoryProductsBloc,
              builder: (context, state) {
                print('Category Products :: $state');
                if (state is LoadCategoryProductsInProgressState ||
                    state is InitialCategoryProductsState) {
                  return GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1 / 1.6,
                      crossAxisSpacing: 16.0,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                } else if (state is LoadCategoryProductsFailedState) {
                  return Center(
                    child: Text(
                      'Failed to load products!',
                      style: GoogleFonts.poppins(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  );
                } else if (state is LoadCategoryProductsCompletedState) {
                  print('BUILD');
                  print(state.productList.length);
                  if (state.productList.length == 0) {
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
                          'No products in this category!',
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
                  }
                  productList = state.productList;
                  //categorize them

                  int i = 0;
                  tabViews = List();

                  for (var subCategory in widget.subCategories) {
                    List<Product> tempList = List();

                    for (var item in productList) {
                      if (item.subCategory.toLowerCase() ==
                          subCategory['subCategoryName']
                              .toString()
                              .toLowerCase()) {
                        tempList.add(item);
                      }
                    }

                    if (tempList.length == 0) {
                      tabViews.add(
                        Column(
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
                              'No products in this category!',
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
                        ),
                      );
                    } else {
                      tabViews.add(
                        GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 1 / 1.6,
                            crossAxisSpacing: 16.0,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: tempList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return ProductListItem(
                              product: tempList[index],
                              cartBloc: widget.cartBloc,
                              currentUser: widget.firebaseUser,
                            );
                          },
                        ),
                      );
                    }
                    i++;
                  }

                  return TabBarView(
                    children: tabViews,
                    controller: _tabController,
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
}
