import 'package:grocery_store/blocs/card_bloc/card_bloc.dart';
import 'package:grocery_store/screens/add_card_screen.dart';
import 'package:grocery_store/screens/edit_card_screen.dart';
import 'package:grocery_store/widget/all_category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/card.dart' as prefix;

class AllCardsScreen extends StatefulWidget {
  @override
  _AllCardsScreenState createState() => _AllCardsScreenState();
}

class _AllCardsScreenState extends State<AllCardsScreen> {
  CardBloc cardBloc;
  List backview;
  List<prefix.Card> cardsList;

  @override
  void initState() {
    super.initState();

    cardsList = List();
    backview = List();

    cardBloc = BlocProvider.of<CardBloc>(context);
    cardBloc.add(GetAllCardsEvent());
  }

  Future sendToEditCard(prefix.Card cardsList, int index) async {
    bool isEdited = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCardScreen(
          cardsList,
          index,
        ),
      ),
    );

    if (isEdited != null) {
      if (isEdited) {
        cardBloc.add(GetAllCardsEvent());
      }
    }
  }

  Future sendToAddCard() async {
    bool isAdded = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCardScreen(),
      ),
    );

    if (isAdded != null) {
      if (isAdded) {
        cardBloc.add(GetAllCardsEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      'Saved Cards',
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  BlocBuilder(
                    cubit: cardBloc,
                    buildWhen: (previous, current) {
                      if (current is GetAllCardsCompletedState ||
                          current is GetAllCardsInProgressState ||
                          current is GetAllCardsFailedState) {
                        return true;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      if (state is GetAllCardsInProgressState) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is GetAllCardsFailedState) {
                        return Center(
                          child: Text(
                            'FAILED TO GET CARDS',
                            style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        );
                      }
                      if (state is GetAllCardsCompletedState) {
                        if (state.cardsList != null) {
                          cardsList = List<prefix.Card>.from(
                            state.cardsList.map(
                              (e) => prefix.Card.fromJson(e),
                            ),
                          );
                        }
                        if (cardsList.length == 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/credit_card.png',
                                  width: size.width * 0.6,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Text(
                                  'No cards found',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.separated(
                          itemCount: cardsList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 5.0),
                          itemBuilder: (context, index) {
                            backview.add(false);
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                sendToEditCard(cardsList[index], index);
                              },
                              onDoubleTap: () {
                                setState(() {
                                  backview[index] = !backview[index];
                                });
                              },
                              child: CreditCardWidget(
                                cardNumber: cardsList[index].cardNumber,
                                expiryDate: cardsList[index].expiryDate,
                                cardHolderName: cardsList[index].cardHolderName,
                                cvvCode: cardsList[index].cvvCode,
                                showBackView: backview[index],
                                height: 195,
                                width: MediaQuery.of(context).size.width,
                                animationDuration: Duration(milliseconds: 1000),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 0.0,
                            );
                          },
                        );
                      }
                      return SizedBox();
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 45.0,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 0),
                    child: FlatButton(
                      onPressed: () {
                        sendToAddCard();
                      },
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        'Add a card',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
