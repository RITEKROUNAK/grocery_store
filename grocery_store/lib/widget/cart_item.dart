import 'package:grocery_store/blocs/cart_bloc/cart_bloc.dart';
import 'package:grocery_store/config/config.dart';
import 'package:grocery_store/models/cart.dart';
import 'package:grocery_store/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartItem extends StatelessWidget {
  final Size size;
  final Product product;
  final String quantity;
  final User currentUser;
  final CartBloc cartBloc;
  final List<Cart> cartProducts;
  final int index;

  const CartItem({
    @required this.size,
    @required this.product,
    @required this.quantity,
    @required this.cartBloc,
    @required this.currentUser,
    @required this.cartProducts,
    @required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      width: size.width,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Container(
                  width: 104.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(11.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11.0),
                    child: Center(
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/icons/category_placeholder.png',
                        image: product.productImages[0],
                        fit: BoxFit.cover,
                        fadeInDuration: Duration(milliseconds: 250),
                        fadeInCurve: Curves.easeInOut,
                        fadeOutDuration: Duration(milliseconds: 150),
                        fadeOutCurve: Curves.easeInOut,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '${product.name}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.blue.withOpacity(0.5),
                                onTap: () {
                                  print('remove from cart');

                                  cartBloc.add(
                                    RemoveFromCartEvent(
                                        cartProducts[index].product.id,
                                        currentUser.uid),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  width: 38.0,
                                  height: 35.0,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.black.withOpacity(0.45),
                                    size: 24.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        '${product.unitQuantity}',
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        product.inStock ? 'In stock' : 'Out of stock',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          color: product.inStock
                              ? Colors.green.withOpacity(0.8)
                              : Colors.red.withOpacity(0.8),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3.0, right: 3.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '${Config().currency}${product.price}',
                              style: GoogleFonts.poppins(
                                color: Colors.green.shade700,
                                fontSize: 16.5,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Material(
                                    child: InkWell(
                                      splashColor:
                                          Theme.of(context).primaryColor,
                                      onTap: () {
                                        print('decrease');

                                        int tempQuan = int.parse(quantity);
                                        if (tempQuan > 1) {
                                          tempQuan--;
                                          cartBloc.add(
                                            IncreaseQuantityEvent(
                                              productId: cartProducts[index]
                                                  .product
                                                  .id,
                                              quantity: '$tempQuan',
                                              uid: currentUser.uid,
                                            ),
                                          );
                                        }
                                        cartProducts[index].quantity =
                                            '$tempQuan';
                                        print(cartProducts[index].quantity);
                                      },
                                      child: Container(
                                        width: 35.0,
                                        height: 32.0,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColorDark
                                              .withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 32.0,
                                  height: 25.0,
                                  child: Text(
                                    '$quantity',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black54,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Material(
                                    child: InkWell(
                                      splashColor:
                                          Theme.of(context).primaryColor,
                                      onTap: () {
                                        print('increase');

                                        int tempQuan = int.parse(quantity);

                                        tempQuan++;
                                        cartBloc.add(
                                          IncreaseQuantityEvent(
                                            productId:
                                                cartProducts[index].product.id,
                                            quantity: '$tempQuan',
                                            uid: currentUser.uid,
                                          ),
                                        );

                                        cartProducts[index].quantity =
                                            '$tempQuan';
                                        print(cartProducts[index].quantity);
                                      },
                                      child: Container(
                                        width: 35.0,
                                        height: 32.0,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColorDark
                                              .withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 5,
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 8,
          //   ),
          // )
        ],
      ),
    );
  }
}
