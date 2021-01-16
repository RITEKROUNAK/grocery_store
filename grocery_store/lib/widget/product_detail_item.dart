import 'package:carousel_pro/carousel_pro.dart';
import 'package:grocery_store/blocs/product_bloc/post_question_bloc.dart';
import 'package:grocery_store/blocs/product_bloc/product_bloc.dart';
import 'package:grocery_store/blocs/product_bloc/rate_product_bloc.dart';
import 'package:grocery_store/blocs/product_bloc/wishlist_product_bloc.dart';
import 'package:grocery_store/config/config.dart';
import 'package:grocery_store/models/product.dart';
import 'package:grocery_store/screens/all_questions_screen.dart';
import 'package:grocery_store/screens/all_reviews_screen.dart';
import 'package:grocery_store/screens/fullscreen_image_screen.dart';
import 'package:grocery_store/widget/post_question_dialog.dart';
import 'package:grocery_store/widget/rate_product_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'question_answer_item.dart';
import 'review_item.dart';
import 'processing_dialog.dart';

class ProductDetailItem extends StatefulWidget {
  final Product product;
  final User currentUser;
  ProductDetailItem({
    @required this.product,
    @required this.currentUser,
  });

  @override
  _ProductDetailItemState createState() => _ProductDetailItemState();
}

class _ProductDetailItemState extends State<ProductDetailItem> {
  WishlistProductBloc wishlistProductBloc;
  List<Widget> productImages = List();
  double rating;
  String discount;
  ProductBloc productBloc;
  PostQuestionBloc postQuestionBloc;
  RateProductBloc rateProductBloc;

  bool isPostingQuestion;
  bool isRatingProduct;
  bool checkRatingProduct;

  @override
  void initState() {
    super.initState();

    isPostingQuestion = false;
    checkRatingProduct = false;
    isRatingProduct = false;

    wishlistProductBloc = BlocProvider.of<WishlistProductBloc>(context);
    productBloc = BlocProvider.of<ProductBloc>(context);
    postQuestionBloc = BlocProvider.of<PostQuestionBloc>(context);
    rateProductBloc = BlocProvider.of<RateProductBloc>(context);

    rating = 0;
    discount = ((1 -
                (int.parse(widget.product.price) /
                    (int.parse(widget.product.ogPrice)))) *
            100)
        .round()
        .toString();

    if (widget.product.reviews.length == 0) {
    } else {
      if (widget.product.reviews.length > 0) {
        for (var review in widget.product.reviews) {
          rating = rating + double.parse(review.rating);
        }
        rating = rating / widget.product.reviews.length;
      }
    }

    if (widget.product.productImages.length == 0) {
      productImages.add(
        Center(
          child: Text(
            'No product image available',
            style: GoogleFonts.poppins(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.75),
            ),
          ),
        ),
      );
    } else {
      for (var item in widget.product.productImages) {
        productImages.add(
          Center(
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/icons/category_placeholder.png',
              image: item,
              fadeInDuration: Duration(milliseconds: 250),
              fadeInCurve: Curves.easeInOut,
              fadeOutDuration: Duration(milliseconds: 150),
              fadeOutCurve: Curves.easeInOut,
            ),
          ),
        );
      }
    }

    wishlistProductBloc.listen((state) {
      if (state is AddToWishlistCompletedState) {
        print('Added to wishlist');
      }
    });

    postQuestionBloc.listen((state) {
      print('$state');

      if (state is PostQuestionInProgressState) {
        //show popup
        isPostingQuestion = true;
        Navigator.pop(context);
        showUpdatingDialog('Posting your question..\nPlease wait!');
      }
      if (state is PostQuestionFailedState) {
        //show failed popup
        if (isPostingQuestion) {
          Navigator.pop(context);
          showSnack('Failed to post question!', context);
          isPostingQuestion = false;
        }
      }
      if (state is PostQuestionCompletedState) {
        //show popup
        if (isPostingQuestion) {
          Navigator.pop(context);
          showPostedSnack('Posted your question!', context);
          isPostingQuestion = false;

          productBloc.add(LoadProductEvent(widget.product.id));
        }
      }
    });

    rateProductBloc.listen((state) {
      print('RATE PRODUCT BLOC :: $state');

      if (state is CheckRateProductInProgressState) {
        //show popup
        checkRatingProduct = true;
      }
      if (state is CheckRateProductFailedState) {
        //show failed popup
        if (checkRatingProduct) {
          showSnack('Failed to check!', context);
          checkRatingProduct = false;
        }
      }
      if (state is CheckRateProductCompletedState) {
        //show popup
        if (checkRatingProduct) {
          checkRatingProduct = false;

          if (state.result != null) {
            if (state.result == 'RATED') {
              //already rated
              showRateProductPopup(state.review, 'RATED');
            }
            if (state.result == 'NOT_RATED') {
              //not rated
              showRateProductPopup(state.review, 'NOT_RATED');
            }
            if (state.result == 'NOT_ORDERED') {
              //not ordered
              showSnack('You can\'t rate this product!', context);
            }
          } else {
            showSnack('You can\'t rate this product!', context);
          }
        }
      }

      if (state is RateProductInProgressState) {
        //show popup
        isRatingProduct = true;
        Navigator.pop(context);
        showUpdatingDialog('Posting your rating..\nPlease wait!');
      }
      if (state is RateProductFailedState) {
        //show failed popup
        if (isRatingProduct) {
          Navigator.pop(context);
          showSnack('Failed to post rating!', context);
          isRatingProduct = false;
        }
      }
      if (state is RateProductCompletedState) {
        //show popup
        if (isRatingProduct) {
          Navigator.pop(context);
          showPostedSnack('Posted your rating!', context);
          isRatingProduct = false;

          productBloc.add(LoadProductEvent(widget.product.id));
        }
      }
    });
  }

  showUpdatingDialog(String s) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProcessingDialog(
          message: s,
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

  void showPostedSnack(String text, BuildContext context) {
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
      duration: Duration(milliseconds: 2000),
      icon: Icon(
        Icons.done,
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

  Future showPostQuestionPopup() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return PostQuestionDialog(
          postQuestionBloc,
          widget.currentUser.uid,
          widget.product.id,
        );
      },
    );
  }

  Future showRateProductPopup(Review review, String result) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return RateProductDialog(
          rateProductBloc,
          widget.currentUser.uid,
          widget.product.id,
          review,
          result,
          widget.product,
        );
      },
    );
  }

  Future<void> _createDynamicLink(bool short) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: Config().urlPrefix,
      link: Uri.parse('${Config().urlPrefix}/${widget.product.id}'),
      androidParameters: AndroidParameters(
        packageName: Config().packageName,
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: widget.product.name,
        imageUrl: Uri.parse(widget.product.productImages[0]),
        description: 'Check out this amazing product',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    await FlutterShare.share(
      title: 'Checkout this product',
      text: '${widget.product.name}',
      linkUrl: url.toString(),
      chooserTitle: 'Share to apps',
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 240.0,
          width: size.width,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                child: Container(
                  height: 180.0,
                  padding: const EdgeInsets.only(
                      bottom: 20.0, left: 16.0, right: 16.0, top: 10.0),
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25.0),
                      bottomRight: Radius.circular(25.0),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                width: size.width,
                child: Container(
                  height: 230.0,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 15.0,
                        offset: Offset(1, 10.0),
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Carousel(
                      images: productImages,
                      dotSize: 4.0,
                      dotSpacing: 15.0,
                      dotColor: Colors.lightGreenAccent,
                      dotIncreasedColor: Colors.amber,
                      autoplayDuration: Duration(milliseconds: 3000),
                      autoplay: false,
                      showIndicator: true,
                      indicatorBgPadding: 5.0,
                      dotBgColor: Colors.transparent,
                      borderRadius: false,
                      animationDuration: Duration(milliseconds: 450),
                      animationCurve: Curves.easeInOut,
                      boxFit: BoxFit.contain,
                      dotVerticalPadding: 5.0,
                      dotPosition: DotPosition.bottomCenter,
                      noRadiusForIndicator: true,
                      onImageTap: (index) {
                        print('Tapped: $index');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImageScreen(
                              images: widget.product.productImages,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                child: Text(
                  widget.product.name,
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.75),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 10.0,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Material(
                      child: InkWell(
                        splashColor: Colors.blue.withOpacity(0.5),
                        onTap: () {
                          print('Wishlist');
                          wishlistProductBloc.add(AddToWishlistEvent(
                            widget.product.id,
                            widget.currentUser.uid,
                          ));
                        },
                        child: Container(
                          width: 38.0,
                          height: 35.0,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(
                            Icons.favorite_border,
                            color: Colors.black.withOpacity(0.5),
                            size: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Material(
                      child: InkWell(
                        splashColor: Colors.blue.withOpacity(0.5),
                        onTap: () {
                          print('Share');
                          _createDynamicLink(true);
                        },
                        child: Container(
                          width: 38.0,
                          height: 35.0,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(
                            Icons.share,
                            color: Colors.black.withOpacity(0.5),
                            size: 20.0,
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
        SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '${Config().currency}${widget.product.price}',
                overflow: TextOverflow.clip,
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.9),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                '${Config().currency}${widget.product.ogPrice}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.black54,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Text(
                '$discount% off',
                maxLines: 1,
                style: GoogleFonts.poppins(
                  fontSize: 14.0,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                widget.product.inStock ? 'In stock' : 'Out of stock',
                maxLines: 1,
                style: GoogleFonts.poppins(
                  fontSize: 15.0,
                  color: widget.product.inStock
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.green.shade300,
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Unit:',
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      widget.product.unitQuantity,
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text(
                    'Free Delivery',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13.0,
                      color: Colors.brown,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text(
                    'Easy cancellation',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13.0,
                      color: Colors.brown,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(),
        ),
        SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Description',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                widget.product.description,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(),
        ),
        SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Additional Information',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                widget.product.additionalInfo.bestBefore.length == 0
                    ? '\u2022 Best before: NA'
                    : '\u2022 Best before: ${widget.product.additionalInfo.bestBefore}',
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                widget.product.additionalInfo.manufactureDate.length == 0
                    ? '\u2022 Manufacture date: NA'
                    : '\u2022 Manufacture date: ${widget.product.additionalInfo.manufactureDate}',
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                widget.product.additionalInfo.shelfLife.length == 0
                    ? '\u2022 Shelf life: NA'
                    : '\u2022 Shelf life: ${widget.product.additionalInfo.shelfLife}',
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                widget.product.additionalInfo.brand.length == 0
                    ? '\u2022 Brand: NA'
                    : '\u2022 Brand: ${widget.product.additionalInfo.brand}',
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(),
        ),
        SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Questions & Answers',
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Container(
                    height: 33.0,
                    child: FlatButton(
                      onPressed: () {
                        //post question
                        showPostQuestionPopup();
                      },
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'Post Question',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              widget.product.queAndAns.length == 0
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'No questions found!',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 10.0),
                          itemBuilder: (context, index) {
                            return QuestionAnswerItem(
                                widget.product.queAndAns[index]);
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemCount: widget.product.queAndAns.length > 3
                              ? 3
                              : widget.product.queAndAns.length,
                        ),
                        widget.product.queAndAns.length > 3
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Divider(),
                                  Container(
                                    height: 36.0,
                                    width: double.infinity,
                                    child: FlatButton(
                                      onPressed: () {
                                        //TODO: take to all questions screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AllQuestionsScreen(
                                                    widget.product.queAndAns),
                                          ),
                                        );
                                      },
                                      color: Colors.transparent,
                                      padding: const EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'View All Questions',
                                          style: GoogleFonts.poppins(
                                            color: Colors.black87,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(),
        ),
        SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Reviews & Ratings',
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Container(
                    height: 33.0,
                    child: FlatButton(
                      onPressed: () {
                        //rate
                        rateProductBloc.add(CheckRateProductEvent(
                          widget.currentUser.uid,
                          widget.product.id,
                          widget.product,
                        ));
                      },
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'Rate Product',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          '${widget.product.reviews.length}',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.poppins(
                            color: Colors.green.shade700,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'reviews',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.poppins(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          widget.product.reviews.length == 0
                              ? '0'
                              : '${rating.toStringAsFixed(1)}',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.poppins(
                            color: Colors.green.shade700,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 1.5),
                          child: Text(
                            '\u2605',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              widget.product.reviews.length == 0
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Center(
                        child: Text(
                          'No reviews found!',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 10.0),
                          itemBuilder: (context, index) {
                            return ReviewItem(
                              review: widget.product.reviews[index],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemCount: widget.product.reviews.length > 3
                              ? 3
                              : widget.product.reviews.length,
                        ),
                        widget.product.reviews.length > 3
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Divider(),
                                  Container(
                                    height: 36.0,
                                    width: double.infinity,
                                    child: FlatButton(
                                      onPressed: () {
                                        //TODO: take to all reviews screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AllReviewsScreen(
                                              widget.product.reviews,
                                              rating,
                                            ),
                                          ),
                                        );
                                      },
                                      color: Colors.transparent,
                                      padding: const EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'View All Reviews',
                                          style: GoogleFonts.poppins(
                                            color: Colors.black87,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
