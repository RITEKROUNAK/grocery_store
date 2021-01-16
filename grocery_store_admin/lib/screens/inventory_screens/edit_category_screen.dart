import 'dart:io';

import 'package:ecommerce_store_admin/blocs/inventory_bloc/all_categories_bloc.dart';
import 'package:ecommerce_store_admin/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:ecommerce_store_admin/models/category.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/add_sub_category_dialog.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/delete_confirm_dialog.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/deleted_dialog.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/processing_dialog.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/product_added_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditCategoryScreen extends StatefulWidget {
  final Category category;

  const EditCategoryScreen({this.category});
  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var image;
  var newImage;
  List subCategories;
  Map<dynamic, dynamic> categoryMap = Map();

  AllCategoriesBloc allCategoriesBloc;
  bool isEditing;
  bool isDeleting;

  @override
  void initState() {
    super.initState();

    subCategories = List();
    allCategoriesBloc = BlocProvider.of<AllCategoriesBloc>(context);
    isEditing = false;
    isDeleting = false;

    for (var item in widget.category.subCategories) {
      subCategories.add({
        'subCategoryName': item.subCategoryName,
      });
    }

    image = widget.category.imageLink;

    allCategoriesBloc.listen((state) {
      print('ALL CATEGORIES STATE :: $state');

      if (state is EditCategoryInProgressState) {
        //in progress
        showUpdatingDialog('Updating category..\nPlease wait!');
      }
      if (state is EditCategoryFailedState) {
        //failed
        if (isEditing) {
          Navigator.pop(context);
          showSnack('Failed to update the category!', context);
          isEditing = false;
        }
      }
      if (state is EditCategoryCompletedState) {
        //completed
        if (isEditing) {
          isEditing = false;
          Navigator.pop(context);
          showCategoryUpdatedDialog();
        }
      }

      if (state is DeleteCategoryInProgressState) {
        //in progress
        showUpdatingDialog('Deleting category..\nPlease wait!');
      }
      if (state is DeleteCategoryFailedState) {
        //failed
        if (isDeleting) {
          Navigator.pop(context);
          showSnack('Failed to delete the category!', context);
          isDeleting = false;
        }
      }
      if (state is DeleteCategoryCompletedState) {
        //completed
        if (isDeleting) {
          isDeleting = false;
          Navigator.pop(context);
          showDeletedCategoryDialog();
        }
      }
    });
  }

  Future cropImage(context) async {
    newImage = await ImagePicker().getImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: newImage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        cropStyle: CropStyle.rectangle,
        compressFormat: ImageCompressFormat.jpg,
        maxHeight: 400,
        maxWidth: 400,
        compressQuality: 50,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop image',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          showCropGrid: false,
          lockAspectRatio: true,
          statusBarColor: Theme.of(context).primaryColor,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
        ));

    if (croppedFile != null) {
      print('File size: ' + croppedFile.lengthSync().toString());
      setState(() {
        newImage = croppedFile;
        image = null;
      });
    } else {
      //not croppped

    }
  }

  Future showAddSubCategoryDialog() async {
    String subCategoryName = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AddSubCategoryDialog();
      },
    );

    if (subCategoryName != null) {
      //add to list
      setState(() {
        subCategories.add({
          'subCategoryName': subCategoryName,
        });
      });
    }

    print(subCategories);
  }

  editCategory() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (image != null || newImage != null) {
        categoryMap.putIfAbsent('categoryImage', () => image);
        categoryMap.putIfAbsent('newImage', () => newImage);
        categoryMap.putIfAbsent('subCategories', () => subCategories);
        categoryMap.putIfAbsent('categoryId', () => widget.category.categoryId);

        allCategoriesBloc.add(EditCategoryEvent(categoryMap));
        isEditing = true;
      } else {
        showSnack('Please fill all the details!', context);
      }
    }
  }

  showDeleteProductDialog() async {
    bool res = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return DeleteConfirmDialog(
          message:
              'Deleting a category can affect your products that are using the category.\n\nDo you still want to delete this category?',
        );
      },
    );

    if (res == true) {
      //delete
      allCategoriesBloc.add(DeleteCategoryEvent(widget.category.categoryId));
      isDeleting = true;
    }
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

  showUpdatingDialog(String message) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProcessingDialog(
          message: message,
        );
      },
    );
  }

  showDeletedCategoryDialog() async {
    bool res = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return DeletedDialog(
          message: 'Deleted the category!',
        );
      },
    );

    if (res == true) {
      //deleted
      Navigator.pop(context, true);
    }
  }

  showCategoryUpdatedDialog() async {
    var res = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProductAddedDialog(
          message: 'Category updated successfully!',
        );
      },
    );

    if (res == 'ADDED') {
      //added
      Navigator.pop(context, true);
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
                      'Edit Category',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 19.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        validator: (String val) {
                          if (val.trim().isEmpty) {
                            return 'Category name is required';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          categoryMap.update(
                            'categoryName',
                            (oldVal) => val.trim(),
                            ifAbsent: () => val.trim(),
                          );
                        },
                        initialValue: widget.category.categoryName,
                        enableInteractiveSelection: false,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15.0),
                          helperStyle: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.65),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          errorStyle: GoogleFonts.poppins(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.black54,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          labelText: 'Category name',
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Category Image',
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      image != null
                          ? Center(
                              child: Container(
                                width: size.width * 0.4,
                                height: size.width * 0.4,
                                child: Stack(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Center(
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                              'assets/icons/category_placeholder.png',
                                          image: widget.category.imageLink,
                                          fit: BoxFit.cover,
                                          fadeInDuration:
                                              Duration(milliseconds: 250),
                                          fadeInCurve: Curves.easeInOut,
                                          fadeOutDuration:
                                              Duration(milliseconds: 150),
                                          fadeOutCurve: Curves.easeInOut,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 5.0,
                                      right: 5.0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          6.0,
                                        ),
                                        child: Material(
                                          color: Colors.red,
                                          child: InkWell(
                                            splashColor:
                                                Colors.white.withOpacity(0.4),
                                            onTap: () {
                                              //remove image
                                              setState(() {
                                                image = null;
                                              });
                                            },
                                            child: Container(
                                              width: 28.0,
                                              height: 28.0,
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 18.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(),
                      newImage != null
                          ? Center(
                              child: Container(
                                width: size.width * 0.4,
                                height: size.width * 0.4,
                                child: Stack(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(newImage),
                                    ),
                                    Positioned(
                                      top: 5.0,
                                      right: 5.0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          6.0,
                                        ),
                                        child: Material(
                                          color: Colors.red,
                                          child: InkWell(
                                            splashColor:
                                                Colors.white.withOpacity(0.4),
                                            onTap: () {
                                              //remove image
                                              setState(() {
                                                newImage = null;
                                              });
                                            },
                                            child: Container(
                                              width: 28.0,
                                              height: 28.0,
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 18.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        height: 45.0,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: FlatButton(
                          onPressed: () {
                            //add product
                            cropImage(context);
                          },
                          color: Colors.green.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                                size: 20.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                (image == null) && (newImage == null)
                                    ? 'Add Image'
                                    : 'Change Image',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            'Sub Categories',
                            style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Material(
                              color: Theme.of(context).primaryColor,
                              child: InkWell(
                                splashColor: Colors.white.withOpacity(0.5),
                                onTap: () {
                                  //add sub category
                                  showAddSubCategoryDialog();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  width: 35.0,
                                  height: 35.0,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 23.0,
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
                      Text(
                        'NOTE: Deleting previously added sub-categories may interfere with products that are using the sub-category so try to avoid doing so.',
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(),
                      SizedBox(
                        height: 5.0,
                      ),
                      subCategories.length == 0
                          ? Center(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'No Sub-Categories added',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black87,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(0.0),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ListTile(
                                  trailing: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      6.0,
                                    ),
                                    child: Material(
                                      color: Colors.red,
                                      child: InkWell(
                                        splashColor:
                                            Colors.white.withOpacity(0.4),
                                        onTap: () {
                                          //remove image
                                          setState(() {
                                            subCategories.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          width: 32.0,
                                          height: 32.0,
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  dense: true,
                                  contentPadding: const EdgeInsets.all(0.0),
                                  title: Text(
                                    '${index + 1}. ${subCategories[index]['subCategoryName']}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black87,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 0.0,
                                );
                              },
                              itemCount: subCategories.length),
                      SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        height: 45.0,
                        width: double.infinity,
                        child: FlatButton(
                          onPressed: () {
                            // //TODO: temp disabled
                            // showSnack(
                            //     'You\'re not a Primary admin.\nAction not allowed!',
                            //     context);

                            //edit category
                            editCategory();
                          },
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FaIcon(
                                FontAwesomeIcons.atom,
                                color: Colors.white,
                                size: 20.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Update Category',
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
                        height: 10.0,
                      ),
                      Container(
                        height: 45.0,
                        width: double.infinity,
                        child: FlatButton(
                          onPressed: () {
                            // //TODO: temp disabled
                            // showSnack(
                            //     'You\'re not a Primary admin.\nAction not allowed!',
                            //     context);

                            //delete category
                            showDeleteProductDialog();
                          },
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Delete Category',
                                style: GoogleFonts.poppins(
                                  color: Colors.red,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
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
