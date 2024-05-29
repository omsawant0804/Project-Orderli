import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Customer/CustLoginPage.dart';
import '../OtherFiles/Animation.dart';
import '../OtherFiles/RestBackend.dart';
class RestProfile extends StatefulWidget {
  const RestProfile({super.key});

  @override
  State<RestProfile> createState() => _RestProfileState();
}

class _RestProfileState extends State<RestProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Map<String, dynamic>? userData;
  final RestoBackend _userService = RestoBackend();

  getdata() async {
    userData = await _userService.getRestoData();
    _populateUserData();
    print(userData);
  }


  Future<void> _populateUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Fetch user data from Firestore or any other source
        print(userData?['Name']);
        String name = userData?['Name']; // Replace with actual data retrieval
        String email = userData?['Email']; // Replace with actual data retrieval
        String? Phno = userData?['phoneNumber']==null?'':userData?['phoneNumber'];// Get email from Firebase Auth
        // Update text controllers with user data
        print(name);
        _nameController.text = name;
        _mobileController.text = Phno??'';
        _emailController.text=email;
        setState(() {}); // Update UI
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }


  Future<void> _saveUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Get the document reference for the user
        DocumentReference userDocRef = _firestore.collection('Restaurant').doc(user.uid);

        // Prepare the data to be updated
        Map<String, dynamic> updatedUserData = {
          'Name': _nameController.text,
          'phoneNumber': _mobileController.text,
          // Add other fields as needed
        };

        // Update the user data in Firestore
        await userDocRef.update(updatedUserData);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User data saved successfully')),
        );
      }
    } catch (error) {
      print('Error saving user data: $error');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save user data')),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  Future<void> signout() async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context).pushAndRemoveUntil(Right_Animation(
          child: CustLoginPage(), direction: AxisDirection.left),
              (Route<dynamic> route) => false
      );

    });
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFFFC8019),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Call the signOutFirebase function here
                signout();
              },
              child: Text(
                'Log Out',
                style: TextStyle(
                  color: Color(0xFFFC8019),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 100,0, 20),
                    child: CircleAvatar(
                      backgroundImage:AssetImage("assets/images/user.png"),
                      backgroundColor: Color(0xFFF4EFE9),
                      radius: 70,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30,),
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
                          controller: _nameController,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Enter name',
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

              SizedBox(height: 15,),

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
                          readOnly: true,
                          controller: _emailController,
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
              SizedBox(height: 15,),
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
                          controller: _mobileController,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Enter Phonenumber',
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

              SizedBox(height: 30,),
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
                            child: Text('Save',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () async {
                              _saveUserData();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 70,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Color(0xFFA7A7A7),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child:  TextButton(
                          onPressed: (){
                            showLogoutDialog(context);
                          },
                          child:Text("Log out",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )
                      )
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
