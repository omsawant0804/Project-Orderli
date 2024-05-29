import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:orderligui/Customer/CustBootomNav.dart';
import 'package:orderligui/Customer/CustLoginPage.dart';
import 'package:orderligui/OtherFiles/Animation.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationPage extends StatefulWidget {
  final String vid;
  final String phno;
  VerificationPage({super.key,required this.vid, required this.phno}){
    print(phno);
  }

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool d=true;
  int resendTime=30;
  late Timer countdownTimer;
  TextEditingController otpText=TextEditingController();
  var code='';
  sigIn()async{
    PhoneAuthCredential credential=PhoneAuthProvider.credential(
      verificationId: widget.vid,
      smsCode: code,
    );

    try{
      await FirebaseAuth.instance.signInWithCredential(credential).then((value){
        Get.offAll(CustVav());
        d=false;
      });
    }on FirebaseAuthException catch(e){
      Get.snackbar('Invalid OTP', e.code);
    }catch(e){
      Get.snackbar('Invalid OTP', e.toString());
    }
  }
  @override
  void initState() {
    startTimer();
    super.initState();
  }
  startTimer(){
countdownTimer=Timer.periodic(const Duration(seconds: 1),(timer){
  setState(() {
    resendTime--;
  });
  if(resendTime<1){
    countdownTimer.cancel();
    Get.snackbar('Time Out', "please click on re-send otp");
  }
});
  }


  ReSendCode()async{
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: widget.phno,
          verificationCompleted: (PhoneAuthCredential credential){},
          verificationFailed: (FirebaseAuthException e){
            Get.snackbar('Please enter valid phone number', e.code);
          },
          codeSent: (String vid,int? token){
            Get.to(VerificationPage(vid: vid,phno: widget.phno,),);
          },
          codeAutoRetrievalTimeout: (vid){
            if(d){
              Get.snackbar('Time Out', "please click on re-send otp");
            }
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
                              onPressed: (){
                                Navigator.of(context).push(Right_Animation(child: CustLoginPage(),
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
              SizedBox(height: 60,),

              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 10),
                    child: Text(
                      'OTP\nVerification',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFF383838),
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20,),

              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                    child: Text(
                      'OTP has been send to ',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFF383838),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    widget.phno,
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      color: Color(0xFF383838),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 50,),

              PinCodeTextField(
                controller: otpText,
                autoDisposeControllers: false,
                appContext: context,
                length: 6,
                textStyle: TextStyle(
                  fontFamily: 'Readex Pro',
                  color: Color(0xFF383838),
                ),
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                enableActiveFill: false,
                autoFocus: true,
                enablePinAutofill: false,
                errorTextSpace: 16,
                showCursor: true,
                cursorColor: Color(0xFF040404),
                obscureText: false,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  fieldHeight: 44,
                  fieldWidth: 44,
                  borderWidth: 2,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  shape: PinCodeFieldShape.box,
                  activeColor: Color(0xFF383838),
                  inactiveColor: Color(0xFF383838),
                  selectedColor: Color(0xFF383838),
                  selectedFillColor: Color(0xFF383838),
                ),
                onChanged: (value) {
                  setState(() {
                    code=value;
                  });
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // validator: _model.pinCodeControllerValidator.asValidator(context),
              ),

              SizedBox(height: 60,),
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
                            child: Text('Verify',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: ()async{
                              sigIn();

                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50,),
              resendTime!=0?resendTime<10?Text("00:0$resendTime",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ):Text("00:$resendTime",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ):const Text("00:00",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40,),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t get it?',
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      color: Color(0xFF383838),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  resendTime==0 ? GestureDetector(
                    onTap: (){
                      ReSendCode();
                      resendTime=30;
                      startTimer();
                      Get.snackbar('OTP Re-send', "otp send to ${widget.phno}");
                    },
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                      child: Text(
                        'Re-Send OTP (SMS)',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          color: Color(0xFF383838),
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ):Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                    child: Text(
                      'Send OTP (SMS)',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFF868383),
                        decoration: TextDecoration.underline,
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
