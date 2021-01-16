import 'package:grocery_store/blocs/cart_bloc/cart_bloc.dart';
import 'package:grocery_store/models/category.dart';
import 'package:grocery_store/screens/sub_categories_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllCategoryItem extends StatelessWidget {
  final Category category;
  final int index;
  final CartBloc cartBloc;
  final User firebaseUser;

  const AllCategoryItem({
    @required this.category,
    @required this.index,
    @required this.cartBloc,
    @required this.firebaseUser,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GestureDetector(
        onTap: () {
          print('go to category');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubCategoriesScreen(
                category: category.categoryName,
                subCategories: category.subCategories,
                selectedCategory: index,
                cartBloc: cartBloc,
                firebaseUser: firebaseUser,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.03),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/icons/category_placeholder.png',
                    image: category.imageLink,
                    fadeInCurve: Curves.easeInOut,
                    fadeInDuration: Duration(milliseconds: 250),
                    fadeOutCurve: Curves.easeInOut,
                    fadeOutDuration: Duration(milliseconds: 150),
                  ),
                ),
              ),
              Container(
                height: 58.0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 10.0,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.03),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: Text(
                  category.categoryName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
