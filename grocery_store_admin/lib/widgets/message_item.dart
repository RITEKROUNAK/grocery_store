import 'package:ecommerce_store_admin/blocs/messages_bloc/messages_bloc.dart';
import 'package:ecommerce_store_admin/models/message.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MessageItem extends StatefulWidget {
  final Size size;
  final QuestionAnswer questionAnswer;
  final String productId;
  final MessagesBloc messagesBloc;

  const MessageItem(
      {this.size, this.questionAnswer, this.messagesBloc, this.productId});

  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
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

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 4.0,
          ),
          Text(
            'Q: ${widget.questionAnswer.que}',
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          widget.questionAnswer.ans.isNotEmpty
              ? Column(
                  children: <Widget>[
                    Text(
                      'A: ${widget.questionAnswer.ans}',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.75),
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 45.0,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          controller: controller,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          enableInteractiveSelection: false,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            color: Colors.black87,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 8.0),
                            border: InputBorder.none,
                            hintText: 'Type your answer',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 14.0,
                              color: Colors.black54,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.blue.withOpacity(0.5),
                          onTap: () {
                            // //TODO: temp disabled
                            // showSnack(
                            //     'You\'re not a Primary admin.\nAction not allowed!',
                            //     context);

                            //add reply
                            if (controller.text.trim().isNotEmpty) {
                              setState(() {
                                widget.questionAnswer.ans =
                                    controller.text.trim();
                              });

                              widget.messagesBloc.add(PostAnswerEvent(
                                id: widget.productId,
                                ans: controller.text.trim(),
                                queId: widget.questionAnswer.queId,
                              ));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            width: 35.0,
                            height: 35.0,
                            child: Icon(
                              Icons.reply,
                              color: Colors.black,
                              size: 22.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Posted by: ${widget.questionAnswer.userName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              '${new DateFormat('dd MMM yyyy, hh:mm a').format(widget.questionAnswer.timestamp.toDate())}',
              style: GoogleFonts.poppins(
                color: Colors.black.withOpacity(0.55),
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
