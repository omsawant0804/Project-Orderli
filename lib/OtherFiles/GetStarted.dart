import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orderligui/Customer/CustLoginPage.dart';
import 'dart:async';
import 'package:orderligui/OtherFiles/Animation.dart';

import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPageChange();
  }

  void _startAutoPageChange() {
    _timer = Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_currentIndex < 4) {
        _currentIndex++;
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      } else {
        _currentIndex = 0;
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 3000),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> _buildPages() {
    return [
      _buildPage(
        imagePath: 'assets/gif/qr.gif',
        title: 'QR Menu',
        description: 'Scan our QR menu for a smarter, faster dining experience!',
      ),
      _buildPage(
        imagePath: 'assets/gif/online.gif',
        title: 'Faster Service',
        description: 'Our QR code system ensures orders reach you in record time!',
      ),
      _buildPage(
        imagePath: 'assets/gif/food.gif',
        title: 'Certified Restaurants',
        description: 'Our system streamlines orders for faster service and happier customers',
      ),
      _buildPage(
        imagePath: 'assets/gif/list.gif',
        title: 'Track Orders',
        description: 'Track Your Meal from Kitchen to Table',
      ),
      _buildPage(
        imagePath: 'assets/gif/payment.gif',
        title: 'Quick Payments',
        description: 'One Tap to Pay, One Tap to Enjoy',
      ),
    ];
  }

  Widget _buildPage({required String imagePath, required String title, required String description}) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imagePath,
            width: 200,
            height: 200,
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 24, // Increase font size for title
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.2, // Add letter spacing for a cleaner look
            ),
          ),
          SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16, // Slightly larger font size for description
              color: Colors.black,
              letterSpacing: 1.0, // Add letter spacing for better readability
              height: 1.4, // Increase line height for better readability
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 16.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFFE86A42) : Color(0xFFE86A42).withOpacity(0.5),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 5; i++) {
      list.add(i == _currentIndex ? _buildIndicator(true) : _buildIndicator(false));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: _buildPages(),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildPageIndicator(),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Container(
                  width: 335,
                  height: 52,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                      )
                    ],
                    gradient: LinearGradient(
                      colors: [Color(0xFFE86A42), Color(0xFFE86A42)],
                      stops: [0, 1],
                      begin: AlignmentDirectional(-1, 0.64),
                      end: AlignmentDirectional(1, -0.64),
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: TextButton(
                        child: Text(
                          'Get Started',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Readex Pro',
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          // Add your navigation or functionality here
                          // Navigator.of(context).pushAndRemoveUntil(Right_Animation(child: CustLoginPage(),
                          //     direction: AxisDirection.right),
                          //         (Route<dynamic> route) => false
                          // );

                          Navigator.pop(context);
                          Get.to(()=>CustLoginPage(),transition: Transition.downToUp,
                            duration: Duration(seconds: 1),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}