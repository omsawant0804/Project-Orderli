import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orderligui/Customer/CustBootomNav.dart';
import 'package:orderligui/Customer/CustHome.dart';

class CustBackend {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkCurrentUserExists() async {
    try {
      // Get current user from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get user document ID
        String documentId = user.uid;

        // Query Firestore to see if document exists
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('User')
            .doc(documentId)
            .get();

        // Return true if document exists, false otherwise
        return documentSnapshot.exists;
      } else {
        // User is not logged in
        return false;
      }
    } catch (error) {
      print('Error checking current user: $error');
      // Return false in case of any error
      return false;
    }
  }


  Future<void> addUser(String? name, String? phoneNumber) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String? documentId = user?.uid;
      // Add new user document to Firestore
      await _firestore.collection('User').doc(documentId).set({
        'Name': name,
        'phnoNumber': phoneNumber,
        // Add other user data fields as needed
      }).then((value) {
        Get.offAll(CustVav());
      });
    } catch (error) {
      print('Error adding user: $error');
      // Handle error
    }
  }



  Future<Map<String, dynamic>> getUserData() async {
    try {
      // Get current user from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get user document ID
        String documentId = user.uid;
        print(documentId);

        // Get document snapshot from Firestore
        DocumentSnapshot documentSnapshot =
        await _firestore.collection('User').doc(documentId).get();

        // Check if document exists
        if (documentSnapshot.exists) {
          // Return user data as a map
          return documentSnapshot.data() as Map<String, dynamic>;
        } else {
          throw Exception('Document does not exist');
        }
      } else {
        throw Exception('User is not logged in');
      }
    } catch (error) {
      print('Error getting user data: $error');
      // Handle error
      throw error;
    }
  }


}


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> fetchUserOrders() {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get the current user's document ID
      String userId = user.uid;

      // Reference to the Order collection
      CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

      // Return a stream of orders where the userId matches the current user's document ID
      return orders.where('userId', isEqualTo: userId).snapshots();
    } else {
      // If user is not logged in, return an empty stream
      return Stream.empty();
    }
  }
}
