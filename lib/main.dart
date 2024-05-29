import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:orderligui/OtherFiles/CheckLogin.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:orderligui/OtherFiles/SplashScreen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(
    apiKey: "AIzaSyDPVdhTeec0Uk2hbR-ZIPdo0WRd78KLhyI",
    appId: "1:788631705999:android:6be4aad6e62e5921fe93fa",
    messagingSenderId: "788631705999",
    projectId: "orderli-7a370",
    storageBucket: "orderli-7a370.appspot.com",
  ));
  FirebaseFirestore.instance.settings=const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Orderli',
      home:SplashScreen(),
    );
  }
}