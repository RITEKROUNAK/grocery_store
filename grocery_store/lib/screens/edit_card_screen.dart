import 'package:grocery_store/blocs/card_bloc/card_bloc.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/card.dart' as prefix;

class EditCardScreen extends StatefulWidget {
  final prefix.Card card;
  final int index;

  EditCardScreen(this.card, this.index);

  @override
  _EditCardScreenState createState() => _EditCardScreenState();
}

class _EditCardScreenState extends State<EditCardScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CreditCardModel creditCardModel;
  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '000');
  FocusNode cvvFocusNode = FocusNode();
  bool isCvvFocused;

  CardBloc cardBloc;
  String cardNo, cardHolderName, expiryDate, cvvCode;

  bool isEdited;

  @override
  void initState() {
    super.initState();

    cardBloc = BlocProvider.of<CardBloc>(context);
    isCvvFocused = false;
    isEdited = false;

    _cardHolderNameController.text = widget.card.cardHolderName;
    _cardNumberController.text = widget.card.cardNumber;
    _expiryDateController.text = widget.card.expiryDate;
    _cvvCodeController.text = widget.card.cvvCode;

    cardNo = widget.card.cardNumber;
    cardHolderName = widget.card.cardHolderName;
    expiryDate = widget.card.expiryDate;
    cvvCode = widget.card.cvvCode;

    creditCardModel = CreditCardModel(
      widget.card.cardNumber,
      widget.card.expiryDate,
      widget.card.cardHolderName,
      widget.card.cvvCode,
      false,
    );

    _cardNumberController.addListener(() {
      setState(() {
        cvvFocusNode.unfocus();
        creditCardModel.cardNumber = _cardNumberController.text;
      });
    });
    _cardHolderNameController.addListener(() {
      setState(() {
        creditCardModel.cardHolderName = _cardHolderNameController.text;
      });
    });
    _expiryDateController.addListener(() {
      setState(() {
        creditCardModel.expiryDate = _expiryDateController.text;
      });
    });
    _cvvCodeController.addListener(() {
      setState(() {
        creditCardModel.cvvCode = _cvvCodeController.text;
      });
    });
    cvvFocusNode.addListener(() {
      setState(() {
        isCvvFocused = cvvFocusNode.hasFocus;
        // creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
      });
    });

    cardBloc.listen((state) {
      if (state is EditCardFailedState) {
        // error
        print('ERROR');
        showSnack('Editing Card Failed!');
        isEdited = false;
      }
      if (state is EditCardInProgressState) {
        print('Editing the CARD');
      }
      if (state is EditCardCompletedState) {
        if (isEdited) {
          print('ADDED');
          Navigator.pop(context, true);
        }
      }
    });
  }

  void showSnack(String text) {
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
                      'Edit card',
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
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: <Widget>[
                CreditCardWidget(
                  cardNumber: creditCardModel.cardNumber,
                  expiryDate: creditCardModel.expiryDate,
                  cardHolderName: creditCardModel.cardHolderName,
                  cvvCode: creditCardModel.cvvCode,
                  showBackView: isCvvFocused,
                  height: 195,
                  width: MediaQuery.of(context).size.width,
                  animationDuration: Duration(milliseconds: 500),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0.0),
                        blurRadius: 15.0,
                        spreadRadius: 2.0,
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'CARD NUMBER',
                          style: GoogleFonts.poppins(
                            color: Colors.black38,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          height: 45.0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 0.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: TextFormField(
                            controller: _cardNumberController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            enableInteractiveSelection: false,
                            onChanged: (value) {
                              if (value.length <= 19) {
                                cardNo = value.trim();
                                print(cardNo);
                              }
                            },
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black87,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w500,
                              wordSpacing: 4.0,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 8.0),
                              border: InputBorder.none,
                              hintText: 'XXXX XXXX XXXX XXXX',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.black54,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400,
                                wordSpacing: 4.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'NAME ON CARD',
                          style: GoogleFonts.poppins(
                            color: Colors.black38,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          height: 45.0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 0.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: TextFormField(
                            controller: _cardHolderNameController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            textCapitalization: TextCapitalization.words,
                            enableInteractiveSelection: false,
                            onChanged: (value) {
                              cardHolderName = value.trim();
                              print(value);
                            },
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black87,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 8.0),
                              border: InputBorder.none,
                              hintText: 'XXXXX XXXXX',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 14.5,
                                color: Colors.black54,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'EXPIRY DATE',
                          style: GoogleFonts.poppins(
                            color: Colors.black38,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          height: 48.0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 0.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: TextFormField(
                            controller: _expiryDateController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            enableInteractiveSelection: false,
                            onChanged: (value) {
                              if (value.length <= 5) {
                                expiryDate = value.trim();
                                print(value);
                              }
                            },
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black87,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 8.0),
                              border: InputBorder.none,
                              hintText: 'MM/YY',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 14.5,
                                color: Colors.black54,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'CVV',
                          style: GoogleFonts.poppins(
                            color: Colors.black38,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          height: 45.0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 0.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: TextFormField(
                            focusNode: cvvFocusNode,
                            controller: _cvvCodeController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            enableInteractiveSelection: false,
                            onChanged: (value) {
                              if (value.length <= 3) {
                                cvvCode = value.trim();
                                print(value);
                              }
                            },
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black87,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 8.0),
                              border: InputBorder.none,
                              hintText: 'XXX',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 14.5,
                                color: Colors.black54,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  height: 50.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FlatButton(
                    onPressed: () {
                      print(cardNo);
                      print(cardHolderName);
                      print(cvvCode);
                      print(expiryDate);

                      Map<String, dynamic> cardMap = Map();
                      if (cardNo.toString().trim().length < 19 ||
                          cardHolderName.toString().isEmpty ||
                          expiryDate.toString().trim().length < 5 ||
                          cvvCode.toString().length < 3) {
                        //show snack
                        showSnack('Invalid card values');
                      } else {
                        cardMap.putIfAbsent('cardNumber', () => cardNo);
                        cardMap.putIfAbsent(
                            'cardHolderName', () => cardHolderName);
                        cardMap.putIfAbsent('expiryDate', () => expiryDate);
                        cardMap.putIfAbsent('cvvCode', () => cvvCode);

                        //send card to edit event
                        cardBloc.add(
                          EditCardEvent(
                            cardMap,
                            widget.index,
                          ),
                        );
                        print('started');
                        setState(() {
                          isEdited = true;
                        });
                      }
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
                          Icons.credit_card,
                          color: Colors.white,
                          size: 25.0,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          'Update Card',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
