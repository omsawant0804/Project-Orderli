import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:orderligui/Customer/CustName.dart';
import 'package:orderligui/OtherFiles/Animation.dart';
import 'package:orderligui/OtherFiles/GetStarted.dart';

import '../OtherFiles/CustomerBackend.dart';

class CustHome extends StatefulWidget {
  CustHome({super.key});

  @override
  State<CustHome> createState() => _CustHomeState();
}

class _CustHomeState extends State<CustHome> {
  final String restaurantId = "";
  final user = FirebaseAuth.instance.currentUser;
  final CustBackend _userService = CustBackend();
  final TextEditingController _name = TextEditingController();
  late Stream<QuerySnapshot> _ordersStream;
  final FirestoreService firestoreService=FirestoreService();



  @override
  void initState() {
    super.initState();
    Check();
    _ordersStream = firestoreService.fetchUserOrders();
  }

  Check() async {
    bool phoneNumberExists = await _userService.checkCurrentUserExists();
    if (!phoneNumberExists) {
      Navigator.of(context).pushReplacement(
          Right_Animation(child: NameField(), direction: AxisDirection.left));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:EdgeInsetsDirectional.fromSTEB(8.0,0, 8.0, 10),
              child: Container(
                width: 400,
                height: 250,
                decoration: BoxDecoration(
                  color: Color(0xFFE86A42),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(70),
                  ),
                ),
                // color: Color(0xFFE86A42),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Ongoing\nOrders",
                      style: TextStyle(
                        fontSize: 38,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(60,0, 0, 100),
                      child: Container(
                        height: 160,
                        child: Image.asset("assets/images/lamp.png"),
                      ),
                    ),
                  ],
                ),
              ),
            ),


            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _ordersStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final orders = snapshot.data!.docs;

                  if (orders.isEmpty) {
                    return Center(child: Container(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                              Container(
                                height: 150,
                                child: Image.asset("assets/images/ordernot.png"),
                              ),
                        Text('No orders yet'),
                      ],
                    )));
                  }

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final orderData = orders[index].data() as Map<String, dynamic>;

                      if (orderData['status'] == 'Delivered') {
                        final deliveredDate = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
                        // Show dialog and move order to history
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Order Delivered'),
                              content: Text('Your order has been delivered.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                          orderData['deliveredDate'] = deliveredDate;
                          // Move the order to the history collection
                          FirebaseFirestore.instance
                              .collection('User')
                              .doc(user?.uid)
                              .collection('orderHistory')
                              .doc(orders[index].id)
                              .set(orderData);

                          // Delete the order from the current orders
                          FirebaseFirestore.instance
                              .collection('orders')
                              .doc(orders[index].id)
                              .delete();
                        });
                      }

                      return OrderCard(
                        orderData: orderData,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class OrderCard extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderCard({
    Key? key,
    required this.orderData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String restoName = orderData['restoName'];
    final double totalAmount = orderData['totalAmount'] ?? 0.0;
    final Map<String, dynamic> items = orderData['items'];
    final String additionalNote = orderData['additionalNote'] ?? '';
    final String status = orderData['status'] ?? 'Pending';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Restaurant Name: $restoName',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Total Amount: ₹${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Additional Note: $additionalNote',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Items:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...items.entries.map((entry) {
              final itemName = entry.key;
              final itemData = entry.value as Map<String, dynamic>;
              final count = itemData['count'];
              final price = itemData['price'];

              return Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$itemName - Count: $count, Price: ₹$price'),
                  ],
                ),
              );
            }).toList(),
            SizedBox(height: 8),
            Text(
              'Status: $status',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
