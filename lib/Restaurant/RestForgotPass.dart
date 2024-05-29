import 'package:flutter/material.dart';
import 'package:orderligui/OtherFiles/Animation.dart';
import 'package:orderligui/Restaurant/RestLoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  @override
  Widget build(BuildContext context) {
   final auth=FirebaseAuth.instance;
    TextEditingController emailController = TextEditingController();
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
                                    Right_Animation(child: RestLogin(),
                                        direction: AxisDirection.left));
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
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(30, 200, 15, 20),
                    child: Text(
                      'Forgot password ? \ndon\'t worry 😟' ,
                      style: TextStyle(
                        fontSize: 25,
                        color: Color(0xFF383838),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
          
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
                SizedBox(height: 25,),
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
                            child: Text('Continue',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () async {
                              auth.sendPasswordResetEmail(email: emailController.text.toString()).then((onValue){
                                Get.snackbar("Successfully send mail", "Check the mail");
                                Navigator.of(context).pushReplacement(
                                    Right_Animation(child: RestLogin(),
                                        direction: AxisDirection.left));
                              }).onError((error,stackTrace){
                                Get.snackbar("Error", error.toString());
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}
