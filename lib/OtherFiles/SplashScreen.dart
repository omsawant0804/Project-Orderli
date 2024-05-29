import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderligui/OtherFiles/GetStarted.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var isLogin=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navv();
  }
  _navv()async{
    await Future.delayed(Duration(seconds: 2),(){});
    // Navigator.pushReplacement(context, Right_Animation(child: OnboardingScreen(),
    //     direction: AxisDirection.up),);
    Navigator.pop(context);
    Get.to(()=>OnboardingScreen(),transition: Transition.fade,
    duration: Duration(seconds: 3),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE86A42),
      body: Center(
          child:Container(
            width: 250,
            height: 250,
            child: Image.asset("assets/images/logo.png"),
          ),

      ),
    );
  }
}
