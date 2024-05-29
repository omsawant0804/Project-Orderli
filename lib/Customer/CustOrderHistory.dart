import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Add the intl package

// Order model and fetchOrders function
class Order {
  final String additionalNote;
  final Map<String, dynamic> items;
  final String userName;
  final int selectedTable;
  final String status;
  final double totalAmount;
  final DateTime timestamp;
  final DateTime deliveredDate;

  Order({
    required this.additionalNote,
    required this.items,
    required this.userName,
    required this.selectedTable,
    required this.status,
    required this.totalAmount,
    required this.timestamp,
    required this.deliveredDate,
  });

  factory Order.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Order(
      additionalNote: data['additionalNote'] ?? '',
      items: data['items'] ?? {},
      userName: data['restoName'] ?? '',
      selectedTable: data['selectedTable'] ?? 0,
      status: data['status'] ?? '',
      totalAmount: data['totalAmount']?.toDouble() ?? 0.0,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      deliveredDate: _parseDate(data['deliveredDate']),
    );
  }

  static DateTime _parseDate(dynamic date) {
    if (date is Timestamp) {
      return date.toDate();
    } else if (date is String) {
      // Replace non-standard separator and parse
      date = date.replaceAll(' – ', 'T');
      return DateTime.parse(date);
    } else {
      throw FormatException("Invalid date format");
    }
  }
}

Future<List<Order>> fetchOrders(String userId) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('User')
        .doc(userId)
        .collection('orderHistory')
        .get();

    return querySnapshot.docs.map((doc) => Order.fromFirestore(doc)).toList();
  } catch (e) {
    print('Error fetching orders: $e');
    rethrow;
  }
}

// OrdersPage widget
class OrdersPage extends StatelessWidget {
  final String userId;

  OrdersPage({this.userId = ""});

  String _formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        child: Column(
          children: [
            Padding(
              padding:EdgeInsetsDirectional.fromSTEB(8.0,0, 8.0, 0),
              child: Container(
                width: 400,
                height: 120,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Order History",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: FutureBuilder<List<Order>>(
                  future: fetchOrders(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Container(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 150,
                            child: Image.asset("assets/images/noOrder.png"),
                          ),
                          Text('No Orders history'),
                        ],
                      )));
                    }

                    List<Order> orders = snapshot.data!;

                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        Order order = orders[index];
                        return Card(
                          margin: EdgeInsets.all(10),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Restaurant: ${order.userName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Text('Table: ${order.selectedTable}'),
                                SizedBox(height: 5),
                                Text('Status: ${order.status}'),
                                SizedBox(height: 5),
                                Text('Total Amount: \$${order.totalAmount.toStringAsFixed(2)}'),
                                SizedBox(height: 5),
                                Text('Ordered at: ${_formatDateTime(order.timestamp)}'),
                                Text('Delivered at: ${_formatDateTime(order.deliveredDate)}'),
                                SizedBox(height: 5),
                                Text('Additional Note: ${order.additionalNote}'),
                                SizedBox(height: 10),
                                Text('Items:'),
                                ...order.items.entries.map((entry) {
                                  return Text('${entry.key}: ${entry.value}');
                                }).toList(),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SecondScreen widget (Example)
class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  bool _loading = true; // Ensure _loading is defined
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // Simulate some loading delay or data fetching here if needed
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : OrdersPage(userId: user!.uid), // Replace with actual logic
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SecondScreen(),
  ));
}
