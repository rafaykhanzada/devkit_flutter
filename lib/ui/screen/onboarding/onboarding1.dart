import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/library/flutter_overboard/overboard.dart';
import 'package:devkitflutter/library/flutter_overboard/page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Onboarding1Page extends StatefulWidget {
  @override
  _Onboarding1PageState createState() => _Onboarding1PageState();
}

class _Onboarding1PageState extends State<Onboarding1Page> {
  // create each page of onBoard here
  final _pageList = [
    PageModel(
        color: Colors.white,
        imageAssetPath: 'assets/images/lamp.jpg',
        title: 'Tutorial 1',
        body: 'This is description of tutorial 1. Lorem ipsum dolor sit amet.',
        doAnimateImage: true),
    PageModel(
        color: Colors.white,
        imageFromUrl: GLOBAL_URL+'/assets/images/onboarding/cart.png',
        title: 'Tutorial 2',
        body: 'This is description of tutorial 2. Lorem ipsum dolor sit amet.',
        doAnimateImage: true),
    PageModel(
        color: Colors.white,
        imageFromUrl: GLOBAL_URL+'/assets/images/onboarding/delivery.png',
        title: 'Tutorial 3',
        body: 'This is description of tutorial 3. Lorem ipsum dolor sit amet.',
        doAnimateImage: true),
    PageModel(
        color: Colors.white,
        imageAssetPath: 'assets/images/lamp.jpg',
        title: 'Tutorial 4',
        body: 'This is description of tutorial 4. Lorem ipsum dolor sit amet.',
        doAnimateImage: true),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark
          ),
          child: OverBoard(
            pages: _pageList,
            showBullets: true,
            finishCallback: () {
              Fluttertoast.showToast(msg: 'Click finish', toastLength: Toast.LENGTH_SHORT);
            },
          ),
        )
    );
  }
}
