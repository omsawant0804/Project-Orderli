import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orderligui/Restaurant/RestName.dart';
import '../OtherFiles/Animation.dart';
import '../OtherFiles/RestBackend.dart';

class RestHome extends StatefulWidget {
  const RestHome({super.key});

  @override
  State<RestHome> createState() => _RestHomeState();
}

class _RestHomeState extends State<RestHome> {
  final FirestoreService firestoreService = FirestoreService();
  final RestoBackend _userService = RestoBackend();
  late Stream<List<Map<String, dynamic>>> _ordersStream;


  Check() async {
    bool emailExists = await _userService.checkCurrentRestoExists();
    if (!emailExists) {
      Navigator.of(context).pushReplacement(
          Right_Animation(child: RestoName(), direction: AxisDirection.left));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Check();
    _ordersStream = firestoreService.fetchRestoOrders();
  }

  void refreshOrders() {
    setState(() {
      // Fetch orders again or update any necessary data
      _ordersStream = firestoreService.fetchRestoOrders();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      child: Text("Active\nOrders",
                        style: TextStyle(
                          fontSize: 38,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(30,0, 0, 0),
                      child: Container(
                        height: 150,
                        child: Image.asset("assets/images/order2.png"),
                      ),
                    ),
                  ],
                ),
              ),
            ),


            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _ordersStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final orders = snapshot.data ?? [];
                  if (orders.isEmpty) {
                    return Center(child: Container(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          child: Image.asset("assets/images/noOrder2.png"),
                        ),
                        Text('No orders yet'),
                      ],
                    )));
                  }
                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final orderData = orders[index];

                      return OrderCard(
                        orderData: orderData,
                        refreshOrders: refreshOrders,// Pass the orderData map
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
  final Function refreshOrders;

  const OrderCard({
    Key? key,
    required this.orderData,required this.refreshOrders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String userName = orderData['userName'];
    final int tableNo = orderData['selectedTable'];
    final String userPhno = orderData['userPhonenumber'];
    final double totalAmount = orderData['totalAmount'] ?? 0.0;
    final Map<String, dynamic> items = orderData['items'];
    final String additionalNote = orderData['additionalNote'] ?? '';
    final String orderId = orderData['orderId']; // Assuming orderId is part of orderData
    final String status = orderData['status'] ?? 'Pending';

    // List of possible statuses
    const List<String> statuses = ['Pending', 'Accept', 'Reject', 'Delivered'];

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User information section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'User Name:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  userName,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'User Phone:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  userPhno,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Order details section
            Text(
              'Order Details:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Amount: ₹${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Table No: $tableNo',
                  style: TextStyle(fontSize: 16),
                ),
                if (additionalNote.isNotEmpty)
                  Text(
                    'Additional Note: $additionalNote',
                    style: TextStyle(fontSize: 16),
                  ),
                SizedBox(height: 8),
                Text(
                  'Items:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                // Table for items
                DataTable(
                  columns: [
                    DataColumn(label: Text('Item Name')),
                    DataColumn(label: Text('Quantity')),
                  ],
                  rows: items.entries.map<DataRow>((entry) {
                    final itemName = entry.key;
                    final itemData = entry.value as Map<String, dynamic>;
                    final count = itemData['count'];

                    return DataRow(cells: [
                      DataCell(Text(itemName)),
                      DataCell(Text(count.toString())),
                    ]);
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Status dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: statuses.contains(status) ? status : null,
                  items: statuses.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newStatus) {
                    if (newStatus != null) {
                      _updateOrderStatus(orderId, newStatus,context);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void _updateOrderStatus(String orderId, String newStatus, BuildContext context) async {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .update({'status': newStatus})
        .then((value) async {
      if (newStatus == 'Delivered') {
        final deliveredDate = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
        final orderSnapshot = await FirebaseFirestore.instance.collection('orders').doc(orderId).get();
        final orderData = orderSnapshot.data() as Map<String, dynamic>;

        orderData['deliveredDate'] = deliveredDate;

        // Add to restaurant's order history
        await FirebaseFirestore.instance
            .collection('Restaurant')
            .doc(orderData['restoId'])
            .collection('orderHistory')
            .doc(orderId)
            .set(orderData);

        // Add to user's order history
        await FirebaseFirestore.instance
            .collection('User')
            .doc(orderData['userId'])
            .collection('orderHistory')
            .doc(orderId)
            .set(orderData);

        // Show dialog box
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Order Delivered'),
              content: Text('Your order has been delivered.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    refreshOrders();
                  },
                  child: Text('Okay'),
                ),
              ],
            );
          },
        );

      }
    })
        .catchError((error) => print('Failed to update status: $error'));
  }
}
