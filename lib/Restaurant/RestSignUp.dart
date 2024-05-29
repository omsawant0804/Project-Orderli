import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orderligui/OtherFiles/Animation.dart';
import 'package:orderligui/Restaurant/RestLoginPage.dart';
import 'package:get/get.dart';
import '../OtherFiles/FirebaseAuthService.dart';

class RestSignUp extends StatefulWidget {
  const RestSignUp({super.key});

  @override
  State<RestSignUp> createState() => _RestSignUpState();
}

class _RestSignUpState extends State<RestSignUp> {
  FirebaseAuthService _auth=FirebaseAuthService();
  TextEditingController emailController=TextEditingController();
  TextEditingController PassController=TextEditingController();
  TextEditingController confirmPassController=TextEditingController();
  var _isObscured = true;


  bool validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? true
        : false;
  }


  bool isPasswordCompliant(String password, [int minLength = 6]) {
    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters = password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length > minLength;

    return !(hasDigits && hasUppercase && hasLowercase && hasSpecialCharacters && hasMinLength);
  }

  bool validateCnPass(){
    if(PassController.text != confirmPassController.text){
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    PassController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SingleChildScrollView(
          child: AppBar(
            automaticallyImplyLeading: false,
            actions: [],
            flexibleSpace: FlexibleSpaceBar(
              title: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 40, 0, 14),
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
                                Navigator.of(context).push(Right_Animation(child: RestLogin(),
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Restaurant \nSign up",
                          style: TextStyle(
                            fontSize: 38,
                            color: Color(0xFF383838),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 240,
                    child: Image.asset("assets/images/gir2.png"),
                  ),
                ],
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
                                        Icons.visibility_off, color: Colors.grey,)
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
                                EdgeInsetsDirectional.fromSTEB(16, 2, 0, 0),
                                child: TextFormField(
                                  controller: confirmPassController,
                                  autofocus: true,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Confirm Password',
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
                                    child: Text('Sign Up',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: ()async{
                                      print("check");
                                      print(emailController.text);
                                      print(PassController.text);
                                      print(confirmPassController.text);
                                      if(emailController.text.isEmpty || PassController.text.isEmpty || confirmPassController.text.isEmpty){
                                        Get.snackbar("Error","Enter required field");
                                      } else if(validateEmail(emailController.text)){
                                        Get.snackbar("Error","Invalid email address");
                                      }else if(isPasswordCompliant(PassController.text)) {
                                        print("passproblem");
                                        Get.snackbar("Password should contain : ",
                                            "minLength: 6\nuppercaseChar\nlowercaseChar\nnumericChar\nspecialChar");
                                      }else if(validateCnPass()){
                                        print("cnpass");
                                        Get.snackbar("Error","Password doesn't match");
                                      }else{
                                        SignUp();
                                      }
        
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
        
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  void SignUp()async{
    String email=emailController.text;
    String Pass=PassController.text;

    User? user= await _auth.signUpWithEmailAndPassword(email, Pass);

    if(user != null){
      print("hellojasfa");
      Get.snackbar("SignUp Successfully","please login");
      Navigator.of(context).pushReplacement(Right_Animation(child: RestLogin(),
          direction: AxisDirection.left));
    }

  }
}
