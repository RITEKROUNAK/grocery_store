import 'dart:io';

import 'package:ecommerce_store_admin/blocs/banners_bloc/banners_bloc.dart';
import 'package:ecommerce_store_admin/models/category.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/processing_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../models/banner.dart' as prefix;

class ManageBannersPage extends StatefulWidget {
  @override
  _ManageBannersPageState createState() => _ManageBannersPageState();
}

class _ManageBannersPageState extends State<ManageBannersPage>
    with AutomaticKeepAliveClientMixin {
  BannersBloc bannersBloc;
  prefix.Banner banner;
  List<Category> categories;
  List newTopBannerImages;
  var newMiddleBannerImage;
  var newBottomBannerImage;
  bool inProgress, isFirst;

  @override
  void initState() {
    super.initState();

    inProgress = false;
    isFirst = true;
    newTopBannerImages = List();

    bannersBloc = BlocProvider.of<BannersBloc>(context);
    bannersBloc.add(GetAllBannersEvent());

    bannersBloc.listen((state) {
      print('BANNERS BLOC :: $state');

      if (state is UpdateBannersCompletedState) {
        //completed
        if (inProgress) {
          Navigator.pop(context);
          inProgress = false;
          showCompletedSnack('Updated banner details successfully', context);
          bannersBloc.add(GetAllBannersEvent());
          isFirst = true;
        }
      }
      if (state is UpdateBannersFailedState) {
        //failed
        if (inProgress) {
          Navigator.pop(context);
          inProgress = false;
          showSnack('Failed to update banners!', context);
        }
      }
      if (state is UpdateBannersInProgressState) {
        //progress
        if (inProgress) {
          showUpdatingDialog();
        }
      }
    });
  }

  showUpdatingDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProcessingDialog(
          message: 'Updating banner details..\nPlease wait!',
        );
      },
    );
  }

  void showCompletedSnack(String text, BuildContext context) {
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

  updateBannerDetails() async {
    // //TODO: temp disabled
    // showSnack('You\'re not a Primary admin.\nAction not allowed!', context);

    if (banner.bottomBanner.category != null &&
        banner.middleBanner.category != null) {
      //proceed
      Map bannerMap = Map();
      bannerMap.putIfAbsent('topBanner', () => banner.topBanner);
      bannerMap.putIfAbsent('newTopBannerImages', () => newTopBannerImages);
      bannerMap.putIfAbsent('bottomBanner', () => banner.bottomBanner);
      bannerMap.putIfAbsent('newBottomBannerImage', () => newBottomBannerImage);
      bannerMap.putIfAbsent('middleBanner', () => banner.middleBanner);
      bannerMap.putIfAbsent('newMiddleBannerImage', () => newMiddleBannerImage);

      bannersBloc.add(UpdateBannersEvent(bannerMap));
      inProgress = true;
    } else {
      showSnack('Please fill all the requred fields', context);
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

  Future cropTopBannerImage(context) async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
        cropStyle: CropStyle.rectangle,
        compressFormat: ImageCompressFormat.jpg,
        maxHeight: 726,
        maxWidth: 1125,
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
        newTopBannerImages.add(croppedFile);
      });
    }
  }

  Future cropMiddleBannerImage(context) async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        aspectRatio: CropAspectRatio(ratioX: 19.5, ratioY: 9),
        cropStyle: CropStyle.rectangle,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 50,
        maxHeight: 581,
        maxWidth: 1125,
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
        newMiddleBannerImage = croppedFile;
        banner.middleBanner.middleBanner = '';
      });
    }
  }

  Future cropBottomBannerImage(context) async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        aspectRatio: CropAspectRatio(ratioX: 19.5, ratioY: 9),
        cropStyle: CropStyle.rectangle,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 50,
        maxHeight: 581,
        maxWidth: 1125,
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
        newBottomBannerImage = croppedFile;
        banner.bottomBanner.bottomBanner = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocBuilder(
        cubit: bannersBloc,
        buildWhen: (previous, current) {
          if (current is GetAllBannersInProgressState ||
              current is GetAllBannersFailedState ||
              current is GetAllBannersCompletedState) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          print('BANNERS BLOC :: $state');
          if (state is GetAllBannersInProgressState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GetAllBannersFailedState) {
            return Text('FAILED');
          }
          if (state is GetAllBannersCompletedState) {
            banner = state.bannerMap['banner'];
            categories = state.bannerMap['categories'];

            if (isFirst) {
              isFirst = false;
              newTopBannerImages = List();
              newBottomBannerImage = null;
              newMiddleBannerImage = null;
            }

            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              scrollDirection: Axis.vertical,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.01),
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: Colors.black.withOpacity(0.08),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Top Banners',
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Divider(),
                        SizedBox(
                          height: 10.0,
                        ),
                        banner.topBanner.length == 0 &&
                                newTopBannerImages.length == 0
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Center(
                                  child: Text(
                                    'No top banner images found',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        banner.topBanner.length > 0
                            ? ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(0.0),
                                shrinkWrap: true,
                                itemCount: banner.topBanner.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 220.0,
                                    width: size.width,
                                    child: Stack(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            banner.topBanner[index],
                                            fit: BoxFit.cover,
                                            frameBuilder: (context, child,
                                                frame, wasSynchronouslyLoaded) {
                                              if (wasSynchronouslyLoaded) {
                                                return child;
                                              }
                                              return AnimatedOpacity(
                                                child: child,
                                                opacity: frame == null ? 0 : 1,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.easeOut,
                                              );
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          top: 10.0,
                                          right: 10.0,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              6.0,
                                            ),
                                            child: Material(
                                              color: Colors.red,
                                              child: InkWell(
                                                splashColor: Colors.white
                                                    .withOpacity(0.4),
                                                onTap: () {
                                                  //remove image
                                                  setState(
                                                    () {
                                                      banner.topBanner
                                                          .removeAt(index);
                                                    },
                                                  );
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
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 15.0,
                                  );
                                },
                              )
                            : SizedBox(),
                        newTopBannerImages.length > 0
                            ? Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(0.0),
                                    shrinkWrap: true,
                                    itemCount: newTopBannerImages.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        height: 220.0,
                                        width: size.width,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: <Widget>[
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.file(
                                                newTopBannerImages[index],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              top: 5.0,
                                              right: 5.0,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  6.0,
                                                ),
                                                child: Material(
                                                  color: Colors.red,
                                                  child: InkWell(
                                                    splashColor: Colors.white
                                                        .withOpacity(0.4),
                                                    onTap: () {
                                                      //remove image
                                                      setState(() {
                                                        newTopBannerImages
                                                            .removeAt(index);
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
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        height: 15.0,
                                      );
                                    },
                                  ),
                                ],
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Divider(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          height: 45.0,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: FlatButton(
                            onPressed: () {
                              //add product
                              cropTopBannerImage(context);
                            },
                            color: Colors.green.shade500,
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
                                  'Add Image',
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
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.01),
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: Colors.black.withOpacity(0.08),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Middle Banner',
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Divider(),
                        SizedBox(
                          height: 10.0,
                        ),
                        banner.middleBanner.middleBanner.isEmpty &&
                                newMiddleBannerImage == null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Center(
                                  child: Text(
                                    'No middle banner image found',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        banner.middleBanner.middleBanner.isNotEmpty
                            ? Column(
                                children: <Widget>[
                                  Container(
                                    height: 160.0,
                                    width: size.width,
                                    child: Stack(
                                      fit: StackFit.passthrough,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            banner.middleBanner.middleBanner,
                                            fit: BoxFit.cover,
                                            frameBuilder: (context, child,
                                                frame, wasSynchronouslyLoaded) {
                                              if (wasSynchronouslyLoaded) {
                                                return child;
                                              }
                                              return AnimatedOpacity(
                                                child: child,
                                                opacity: frame == null ? 0 : 1,
                                                duration:
                                                    const Duration(seconds: 1),
                                                curve: Curves.easeOut,
                                              );
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          top: 10.0,
                                          right: 10.0,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              6.0,
                                            ),
                                            child: Material(
                                              color: Colors.red,
                                              child: InkWell(
                                                splashColor: Colors.white
                                                    .withOpacity(0.4),
                                                onTap: () {
                                                  //remove image
                                                  setState(
                                                    () {
                                                      banner.middleBanner
                                                          .middleBanner = '';
                                                    },
                                                  );
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
                                ],
                              )
                            : SizedBox(),
                        newMiddleBannerImage != null
                            ? Container(
                                height: 160.0,
                                width: size.width,
                                child: Stack(
                                  fit: StackFit.passthrough,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(
                                        newMiddleBannerImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 10.0,
                                      right: 10.0,
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
                                              setState(
                                                () {
                                                  newMiddleBannerImage = null;
                                                },
                                              );
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
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Divider(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          height: 45.0,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: FlatButton(
                            onPressed: () {
                              //add banner
                              cropMiddleBannerImage(context);
                            },
                            color: Colors.green.shade500,
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
                                  'Add Image',
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
                          height: 20.0,
                        ),
                        Text(
                          'Middle Banner Category: ',
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        InputDecorator(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15.0),
                            labelText: 'Select a category',
                            labelStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 14.5,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          // isEmpty: _selectedCategory == null,
                          child: DropdownButton<String>(
                            underline: SizedBox(
                              height: 0,
                            ),
                            value: banner.middleBanner.category.isEmpty
                                ? null
                                : banner.middleBanner.category,
                            isExpanded: true,
                            isDense: true,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.5,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                            items: categories
                                .map((e) => DropdownMenuItem(
                                      child: Text(e.categoryName),
                                      value: e.categoryName,
                                    ))
                                .toList(),
                            onChanged: (String category) {
                              setState(() {
                                banner.middleBanner.category = category;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.01),
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: Colors.black.withOpacity(0.08),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Bottom Banner',
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Divider(),
                        SizedBox(
                          height: 10.0,
                        ),
                        banner.bottomBanner.bottomBanner.isEmpty &&
                                newBottomBannerImage == null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Center(
                                  child: Text(
                                    'No bottom banner image found',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        banner.bottomBanner.bottomBanner.isNotEmpty
                            ? Column(
                                children: <Widget>[
                                  Container(
                                    height: 160.0,
                                    width: size.width,
                                    child: Stack(
                                      fit: StackFit.passthrough,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            banner.bottomBanner.bottomBanner,
                                            fit: BoxFit.cover,
                                            frameBuilder: (context, child,
                                                frame, wasSynchronouslyLoaded) {
                                              if (wasSynchronouslyLoaded) {
                                                return child;
                                              }
                                              return AnimatedOpacity(
                                                child: child,
                                                opacity: frame == null ? 0 : 1,
                                                duration:
                                                    const Duration(seconds: 1),
                                                curve: Curves.easeOut,
                                              );
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          top: 10.0,
                                          right: 10.0,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              6.0,
                                            ),
                                            child: Material(
                                              color: Colors.red,
                                              child: InkWell(
                                                splashColor: Colors.white
                                                    .withOpacity(0.4),
                                                onTap: () {
                                                  //remove image
                                                  setState(
                                                    () {
                                                      banner.bottomBanner
                                                          .bottomBanner = '';
                                                    },
                                                  );
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
                                ],
                              )
                            : SizedBox(),
                        newBottomBannerImage != null
                            ? Container(
                                height: 160.0,
                                width: size.width,
                                child: Stack(
                                  fit: StackFit.passthrough,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(
                                        newBottomBannerImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 10.0,
                                      right: 10.0,
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
                                              setState(
                                                () {
                                                  newBottomBannerImage = null;
                                                },
                                              );
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
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Divider(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          height: 45.0,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: FlatButton(
                            onPressed: () {
                              //add banner
                              cropBottomBannerImage(context);
                            },
                            color: Colors.green.shade500,
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
                                  'Add Image',
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
                          height: 20.0,
                        ),
                        Text(
                          'Bottom Banner Category: ',
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        InputDecorator(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15.0),
                            labelText: 'Select a category',
                            labelStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 14.5,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          // isEmpty: _selectedCategory == null,
                          child: DropdownButton<String>(
                            underline: SizedBox(
                              height: 0,
                            ),
                            value: banner.bottomBanner.category.isEmpty
                                ? null
                                : banner.bottomBanner.category,
                            isExpanded: true,
                            isDense: true,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.5,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                            items: categories
                                .map((e) => DropdownMenuItem(
                                      child: Text(e.categoryName),
                                      value: e.categoryName,
                                    ))
                                .toList(),
                            onChanged: (String category) {
                              setState(() {
                                banner.bottomBanner.category = category;
                              });
                            },
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
                  height: 45.0,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: FlatButton(
                    onPressed: () {
                      //update banner
                      updateBannerDetails();
                    },
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Text(
                      'Update Banner Details',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
