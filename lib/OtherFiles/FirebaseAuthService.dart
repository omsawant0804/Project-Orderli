import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
class FirebaseAuthService{

  FirebaseAuth _auth = FirebaseAuth.instance;


  Future<User?> signUpWithEmailAndPassword(String email, String password)async{
    try{
      UserCredential credential= await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }on FirebaseAuthException catch(e){
      Get.snackbar('Please enter valid details', e.code);
    }catch(e){
      Get.snackbar('Please enter valid details', e.toString());
    }

    return null;
  }




  Future<User?> signInWithEmailAndPassword(String email, String password)async{
    try{
      UserCredential credential= await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }on FirebaseAuthException catch(e){
      Get.snackbar('Error', e.code);
    }catch(e){
      Get.snackbar('Error', e.toString());
    }

    return null;
  }







}