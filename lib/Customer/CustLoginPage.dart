import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderligui/Customer/CustVerification.dart';
import 'package:orderligui/OtherFiles/Animation.dart';
import 'package:orderligui/Restaurant/RestLoginPage.dart';

class CustLoginPage extends StatefulWidget {
  const CustLoginPage({super.key});

  @override
  State<CustLoginPage> createState() => _CustLoginPageState();
}

class _CustLoginPageState extends State<CustLoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController mobile=TextEditingController();
  SendCode()async{
    print("hello"+mobile.text);
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+91'+mobile.text,
          verificationCompleted: (PhoneAuthCredential credential){},
          verificationFailed: (FirebaseAuthException e){
            Get.snackbar('Please enter valid phone number', e.code);
          },
          codeSent: (String vid,int? token){
            Get.to(VerificationPage(vid: vid,phno: '+91'+mobile.text,),);
          },
          codeAutoRetrievalTimeout: (vid){
          }
      );
    }on FirebaseAuthException catch(e){
      Get.snackbar('Please enter valid Phone number', e.code);
    }catch(e){
      Get.snackbar('Please enter valid Phone number', e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height:50,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 140,
                    width: 350,
                    child: Center(child: Image.asset("assets/images/cust1.png")),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sign in",
                    style: TextStyle(
                      fontSize: 40,
                      color: Color(0xFF383838),
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 30,),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.transparent,
                    // elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      curve: Curves.easeIn,
                      width: 335,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F0F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                            child: Text(
                              '+91',
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Color(0xFF040404),
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Form(
                              key: formKey,
                              autovalidateMode: AutovalidateMode.disabled,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 5),
                                child: TextFormField(
                                  controller: mobile,
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Phone number',
                                    isCollapsed:true,
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
                                  maxLength: 10,
                                  buildCounter: (context,
                                      {required currentLength,
                                        required isFocused,
                                        maxLength}) =>
                                  null,
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        
              SizedBox(height: 26,),
        
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
                            child: Text('Continue',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: ()async{
                              SendCode();
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
                    padding:EdgeInsetsDirectional.fromSTEB(55, 20, 0, 0),
                    child: Text("Are you a restaurant?",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    ),
                  ),
                  Padding(
                    padding:EdgeInsetsDirectional.fromSTEB(6.0, 20,0, 0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(Right_Animation(child: RestLogin(),
                            direction: AxisDirection.left));
                      },
                      child: Text("Click here",
                      style: TextStyle(
                        fontSize: 16,
                        color:Colors.black,
                        fontWeight:FontWeight.bold,
                      ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 55,),
              Row(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 300,
                    child: Image.asset("assets/images/food1.png",),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
