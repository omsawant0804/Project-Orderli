import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../OtherFiles/CustomerBackend.dart';

class NameField extends StatefulWidget {
  const NameField({super.key});

  @override
  State<NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {
  TextEditingController name =TextEditingController();
  final CustBackend _userService = CustBackend();
  String? phno=FirebaseAuth.instance.currentUser?.phoneNumber.toString();
  // AuthService _auth=AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional(-0.97, -0.25),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                child: Text(
                  'You\'re almost there! 👋' ,
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xFF383838),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Container(
                      width: 359,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F0F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding:
                        EdgeInsetsDirectional.fromSTEB(16, 2, 10, 0),
                        child: TextFormField(
                          controller: name,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Enter Your Name',
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
            ),

            Align(
              alignment: AlignmentDirectional(0, 0.25),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.transparent,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: GestureDetector(
                      child: Container(
                        width: 339,
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                          child: Text(
                            'Check Orderli',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      onTap: (){
                        if(name.text.isEmpty){
                          Get.snackbar("Error","Enter Name field!");
                        }else{
                          // _auth.storeUserData(FirebaseAuth.instance.currentUser?.phoneNumber.toString(), name.text.toString());
                          _userService.addUser(name.text.toString(),phno);

                        }

                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}
