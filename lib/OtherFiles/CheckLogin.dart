import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orderligui/Customer/CustBootomNav.dart';
import 'package:orderligui/Customer/CustHome.dart';
import 'package:orderligui/Restaurant/RestHome.dart';
import 'package:orderligui/OtherFiles/GetStarted.dart';
import 'package:orderligui/Restaurant/RestNavBar.dart';

class wraper extends StatefulWidget {
  const wraper({super.key});

  @override
  State<wraper> createState() => _wraperState();
}

class _wraperState extends State<wraper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            if(snapshot.data?.phoneNumber != null){
              return CustVav();
            }else if(snapshot.data?.email!=null){
              return RestVav();
            }else{
              return OnboardingScreen();
            }
          }
      ),
    );
  }
}
