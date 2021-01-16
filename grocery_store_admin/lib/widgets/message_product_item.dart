import 'package:ecommerce_store_admin/blocs/messages_bloc/all_messages_bloc.dart';
import 'package:ecommerce_store_admin/blocs/messages_bloc/messages_bloc.dart';
import 'package:ecommerce_store_admin/blocs/messages_bloc/new_messages_bloc.dart';
import 'package:ecommerce_store_admin/config/config.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/screens/message_screens/view_messages_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageProductItem extends StatefulWidget {
  final Size size;
  final Product product;
  final AllMessagesBloc allMessagesBloc;
  final NewMessagesBloc newMessagesBloc;
  final String screen;
  final MessagesBloc messagesBloc;

  const MessageProductItem({
    this.size,
    this.product,
    this.allMessagesBloc,
    this.newMessagesBloc,
    this.screen,
    this.messagesBloc,
  });

  @override
  _MessageProductItemState createState() => _MessageProductItemState();
}

class _MessageProductItemState extends State<MessageProductItem> {
  int newMessages = 0;

  @override
  void initState() {
    super.initState();

    for (var item in widget.product.queAndAns) {
      if (item.ans.isEmpty) {
        newMessages++;
      }
    }
  }

  Future sendToViewMessages() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewMessagesScreen(
          product: widget.product,
          messagesBloc: widget.messagesBloc,
        ),
      ),
    );

    newMessages = 0;
    for (var item in widget.product.queAndAns) {
      if (item.ans.isEmpty) {
        newMessages++;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: widget.size.width * 0.25,
                height: widget.size.width * 0.25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11.0),
                  child: Center(
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/icons/category_placeholder.png',
                      image: widget.product.productImages[0],
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
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '${widget.product.name}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        Container(
                          width: 30.0,
                          height: 30.0,
                          margin: const EdgeInsets.only(
                              right: 4.0, top: 4.0, left: 4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            '$newMessages',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Total messages: ${widget.product.queAndAns.length}',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.75),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '${Config().currency}${widget.product.price}',
                          style: GoogleFonts.poppins(
                            color: Colors.green.shade700,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${Config().currency}${widget.product.ogPrice}',
                          style: GoogleFonts.poppins(
                            color: Colors.black54,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          FlatButton(
            splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
            onPressed: () {
              sendToViewMessages();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(
                  width: 1.0,
                  color: Colors.black.withOpacity(0.4),
                  style: BorderStyle.solid),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.email,
                  size: 20.0,
                  color: Colors.black.withOpacity(0.7),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  'View Messages',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
