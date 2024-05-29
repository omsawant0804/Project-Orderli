import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orderligui/Customer/CustLoginPage.dart';
import 'package:orderligui/OtherFiles/Animation.dart';
import 'package:orderligui/Restaurant/RestForgotPass.dart';
import 'package:orderligui/Restaurant/RestHome.dart';
import 'package:orderligui/Restaurant/RestNavBar.dart';
import 'package:orderligui/Restaurant/RestSignUp.dart';
import 'package:get/get.dart';

import '../OtherFiles/FirebaseAuthService.dart';

class RestLogin extends StatefulWidget {
  const RestLogin({super.key});

  @override
  State<RestLogin> createState() => _RestLoginState();
}

class _RestLoginState extends State<RestLogin> {
  FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController PassController = TextEditingController();
  var _isObscured = true;

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    PassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SingleChildScrollView(
          child: AppBar(
            automaticallyImplyLeading: false,
            actions: [],
            flexibleSpace: FlexibleSpaceBar(
              title: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 40, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios_new_outlined,
                                color: Colors.black,
                                size: 26,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    Right_Animation(child: CustLoginPage(),
                                        direction: AxisDirection.right));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              expandedTitleScale: 1.0,
            ),
            elevation: 0,
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 160,
                    width: 350,
                    child: Center(child: Image.asset("assets/images/ch1.png")),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Restaurant \nSign in",
                      style: TextStyle(
                        fontSize: 38,
                        color: Color(0xFF383838),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.transparent,
                            // elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Container(
                              width: 335,
                              height: 58,
                              decoration: BoxDecoration(
                                color: Color(0xFFF3F0F0),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(16, 2, 0, 0),
                                child: TextFormField(
                                  controller: emailController,
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: 'Enter email',
                                    hintStyle:
                                    TextStyle(
                                      fontFamily: 'Readex Pro',
                                      fontSize: 16,
                                    ),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'Readex Pro',
                                    color: Color(0xFF040404),
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.transparent,
                            // elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Container(
                              width: 335,
                              height: 58,
                              decoration: BoxDecoration(
                                color: Color(0xFFF3F0F0),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(16, 2, 10, 0),
                                child: TextFormField(
                                  controller: PassController,
                                  autofocus: true,
                                  obscureText: _isObscured,
                                  decoration: InputDecoration(
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isObscured = !_isObscured;
                                        });
                                      },
                                      child: _isObscured
                                          ? const Icon(
                                        Icons.visibility_off,
                                        color: Colors.grey,)
                                          : const Icon(
                                        Icons.visibility, color: Colors.grey,),
                                    ),
                                    hintText: 'Password',
                                    hintStyle:
                                    TextStyle(
                                      fontFamily: 'Readex Pro',
                                      fontSize: 16,
                                    ),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'Readex Pro',
                                    color: Color(0xFF040404),
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 26, 0),
                                child: TextButton(
                                    onPressed:(){
                                      Navigator.of(context).push(
                                          Right_Animation(child: ForgotPass(),
                                              direction: AxisDirection.left));
                                    },
                                    child: Text("Forgot Password ?",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                ),
                              ),
                        ],
                      ),
                      // SizedBox(height: 1,),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.transparent,
                            // elevation: 2,
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
                                  colors: [
                                    Color(0xFFE86A42),
                                    Color(0xFFE86A42)
                                  ],
                                  stops: [0, 1],
                                  begin: AlignmentDirectional(-1, 0.64),
                                  end: AlignmentDirectional(1, -0.64),
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: TextButton(
                                    child: Text('Sign In',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () async {
                                      LogIn();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(40, 14, 0,
                                0),
                            child: Text("You don't have an account?",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(6.0, 14, 0,
                                0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    Right_Animation(child: RestSignUp(),
                                        direction: AxisDirection.left));
                              },
                              child: Text("Sign up",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void LogIn() async {
    String email = emailController.text;
    String Pass = PassController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, Pass);

    if (user != null) {
      Get.snackbar("Login Successfully", "Order delicious meals");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => RestVav(),
        ), (Route<dynamic> route) => false
      );
    }
  }
}