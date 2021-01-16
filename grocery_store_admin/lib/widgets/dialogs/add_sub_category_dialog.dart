import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddSubCategoryDialog extends StatefulWidget {
  @override
  _AddSubCategoryDialogState createState() => _AddSubCategoryDialogState();
}

class _AddSubCategoryDialogState extends State<AddSubCategoryDialog> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      elevation: 5.0,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(
                'Add Sub-Category',
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Container(
              height: 45.0,
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                enableInteractiveSelection: false,textCapitalization: TextCapitalization.words,
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
                  hintText: 'Sub category name',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14.0,
                    color: Colors.black54,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Center(
              child: SizedBox(
                width: size.width * 0.5,
                child: FlatButton(
                  onPressed: () {
                    //add sub category
                    if (controller.text.trim().isNotEmpty) {
                      Navigator.pop(context, controller.text.trim());
                    }
                  },
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'Add',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: size.width * 0.5,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
